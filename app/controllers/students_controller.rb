class StudentsController < ApplicationController
  impressionist

  load_and_authorize_resource
  respond_to :json, :csv

  # Return the list of students available to user
  # If company admin returns all students accessbale to them and who are active
  # If department admin return department students
  # If event_id is specified, only show students attending event
  # GET /students
  # GET /students.json
  def index
    if current_user.is_company_admin?
      @students = current_user.company.accessible_students
    elsif current_user.is_department_admin?
      @students = current_user.department.students
    else
      @students = Student.scoped
    end

    if params.keys.include? "event_id"
      @students = @students.joins(:registered_events).where("event_id = ?", params[:event_id])
    end

    if current_user.is_company_admin?
      @students.select! { |s| s.is_active? }
    end

    respond_with @students
  end


  # Find student for specified id
  #
  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    respond_with @student
  end

  # Create new student
  #
  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new
    respond_with @student
  end

  # Create new student with given parameters
  #
  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])

    if params.has_key? :departments
      departments = params[:departments].map{ |id| Department.find(id) }
    else
      departments = []
    end
    @student.departments = departments

    if @student.save
      respond_with @student, status: :created, location: @student
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # Update specified student with given params
  #
  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])
    begin
      if @student.update_attributes(params[:student])
        respond_with(@student) do |format|
          format.json{render json: @student}
        end
      else
        respond_with @student, status: :unprocessable_entity
      end
    rescue Errno::EACCES
      render status: :internal_server_error, json: {
        errors: {
          dummy_attr: ['The user running the Rails process can\'t write to the uploads directory.']
        }
      }
    end
  end

  # Delete specified student peremantnly. End the session (ie log out) if
  # current user is student.
  # Don't log out otherwise (department deleting student)
  #
  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    if current_user.is_student?
      session[:user_id] = nil
    end
    head :no_content
  end

  # Download student document, e.g. CV
  #
  # GET /students/1/:document_type/:view_type
  def download_document
    @student = Student.find(params[:id])
    if current_user && current_user.is_company_admin?
      impressionist(@student, message: 'company_cv_download')
    end
    document_type = params[:document_type]
    document = (@student.send "#{document_type}".to_sym).path
    ext = File.extname document
    unless document.nil?
      if File.exist?(document)
        if (params.has_key? :preview)
          send_file document, :filename => "#{@student.last_name}_#{@student.first_name}_#{document_type}#{ext}", :disposition => 'inline'
        else
          send_file document, :filename => "#{@student.last_name}_#{@student.first_name}_#{document_type}#{ext}"
        end
      else
        @student.send "#{document_type}=".to_sym, nil
        @student.save
        redirect_to root_path
        return
      end
    else
      head :no_content
    end
  end

  # Delete student document, e.g. CV
  #
  # DELETE /students/1/:document_type
  def delete_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]
    @student.send "#{document_type}=".to_sym, nil

    if @student.save
      respond_with @student
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # Bulk download CVs
  #
  # GET /students/export_cvs
  # TODO: Queue this with resque...
  def export_cvs
    if params.has_key? :students
        t = Tempfile.new("my-temp-filename-#{Time.now}")
        Zip::File.open(t.path, Zip::File::CREATE) do |zipfile|
            @students = params[:students].split(',')
            @students = @students.uniq
            @students.each do |id|
                begin
                    student = Student.find(id)
                    title = "#{student.id}-#{student.last_name}#{student.first_name}-cv.pdf"
                    cv_url = (student.send :cv).path
                    zipfile.add(title, cv_url) if cv_url.present? && File.exist?(cv_url)
                rescue ActiveRecord::RecordNotFound
                end
            end
            zipfile.add("CVs.txt", File.join(Rails.root, "app", "assets", "files", "CVs.txt" ))
        end
        send_file t.path, :type => 'application/zip',
                                     :disposition => 'attachment',
                                     :filename => "CVs.zip"
        t.close
    else
        redirect_to root_path
    end
  end

  # Suggest degrees that student can be
  # This is done by crowdsourcing (i.e. look at every student and obtaining their degree)
  #
  # GET /students/suggested_degrees
  def suggested_degrees
    @students = Student.all
    degrees = []
    @students.each do |student|
      if (not student.degree.to_s.empty?) and (not degrees.include? student.degree)
        degrees.push student.degree
      end
    end
    respond_with degrees
  end

  # Returns company views of students over past week
  #
  # GET /students/view_stats_all
  def view_stats_all
    data = {
      :name => "Student Views",
      :pointInterval => 1.day * 1000,
      :pointStart => 1.weeks.ago.at_midnight.to_i * 1000,
      :data => (1.weeks.ago.to_date..Date.today).map{ |date|
        Impression.where(
          "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
          date.at_beginning_of_day,
          date.tomorrow.at_beginning_of_day,
          'stat_show',
          'students'
        ).count
      }
    }
    respond_with data
  end

  # Returns five highest viewed students in past week
  #
  # GET /students/top_5
  def top_5
    student_impressions = Impression.where(
      "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
      1.weeks.ago.to_date.at_beginning_of_day,
      Date.today.tomorrow.at_beginning_of_day,
      'stat_show',
      'students'
    )

    student_ids = student_impressions.map{ |si| si.impressionable_id }
    student_id_counts = Hash.new(0)
    student_ids.each{|si| student_id_counts[si] += 1}
    student_id_counts.sort_by {|key, value| value}

    # Order student_id_counts by count
    sortable = student_id_counts.map{|k, v| [v, k]}
    sortable.sort!.reverse!

    students = sortable.map{ |count, id| Student.find(id) }

    ok_students = []
    students.each do |s|
      if s.departments.map(&:id).include? current_user.department_id
        ok_students.push(s)
      end
    end

    ok_students.each { |s| s.stat_count = student_id_counts[s.id] }

    respond_with ok_students[0..4]
  end
end
