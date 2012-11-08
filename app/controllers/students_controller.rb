class StudentsController < ApplicationController
  respond_to :json

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
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
    @studentProfile = StudentProfile.new
    @student.profile = @studentProfile
    respond_with @student
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])
    #Student profile bits in here.
    if @student.save
      respond_with @student, status: :created, location: @student
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # POST /students/1/upload_cv
  def upload_cv
    @student = Student.find(params[:student_id])
    # File saved in /tmp
    tempfile = params[:files][0].tempfile

    # Create folder for student id if required
    cv_directory = File.join('cvs', @student.id.to_s())
    Dir.mkdir(cv_directory) unless File.exists?(cv_directory)

    # Make new file name for the CV
    file = File.join(cv_directory, params[:files][0].original_filename)

    # Copy temporary file to new place /cvs
    FileUtils.cp tempfile.path, file

    @student.cv_location = params[:files][0].original_filename
    if @student.save
      respond_with @student
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # GET /students/1/download_cv
  def download_cv
    @student = Student.find(params[:student_id])
    filename = File.join('cvs', @student.id.to_s(), @student.cv_location)
    if @student.cv_location and File.exists?(filename)
      send_file filename
    else
      head :no_content
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])
    #student profile bits in here.
    if @student.update_attributes(params[:student])
      head :no_content
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @studentProfile = StudentProfile.find(@student.profile_id)
    @student.destroy
    @studentProfile.destroy
    head :no_content
  end
end
