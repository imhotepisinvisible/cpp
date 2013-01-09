class StudentsController < ApplicationController
  impressionist

  load_and_authorize_resource
  respond_to :json

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


  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    respond_with @student
  end

  # GET /students/new
  # GET /students/new.json
  def new
    @student = Student.new
    respond_with @student
  end

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

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(params[:student])
      respond_with(@student) do |format|
        format.json{render json: @student}
      end
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy!
    if current_user.is_student?
      session[:user_id] = nil
    end
    head :no_content
  end

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
      if Rails.env.production?
        redirect_to (@student.send "#{document_type}".to_sym).expiring_url(20)
        return
      end

      if (params.has_key? :preview)
        send_file document, :filename => "#{@student.last_name}_#{@student.first_name}_#{document_type}#{ext}", :disposition => 'inline'
      else
        send_file document, :filename => "#{@student.last_name}_#{@student.first_name}_#{document_type}#{ext}"
      end
    else
      head :no_content
    end
  end

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

  def view_stats
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
          'students_controller'
        ).count
      }
    }
    respond_with data
  end
end
