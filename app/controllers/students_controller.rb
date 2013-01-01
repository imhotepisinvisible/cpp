class StudentsController < ApplicationController
  load_and_authorize_resource
  respond_to :json

  # GET /students
  # GET /students.json
  def index
    @students = Student.where(:active => true)
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
    session[:user_id] = nil
    head :no_content
  end

  # GET /students/1/:document_type/:view_type
  def download_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]
    document = (@student.send "#{document_type}".to_sym).path
    ext = File.extname document
    unless document.nil?
      if RAILS_ENV == 'production'
        document = (@student.send "#{document_type}".to_sym).s3_object
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
end
