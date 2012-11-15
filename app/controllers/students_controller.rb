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

  # POST /students/1/upload_document/:document_type
  def upload_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]

    # File saved in /tmp
    tempfile = params[:files][0].tempfile
    extension = File.extname(params[:files][0].original_filename)

    directory = File.join('documents', document_type)

    # Make new file name for the CV
    file = File.join(directory, "#{@student.id}#{extension}")

    # Copy temporary file to new place /cvs
    FileUtils.cp tempfile.path, file

    # Set the correct model attribute
    set_document_location document_type, @student, file

    if @student.save
      respond_with @student
    else
      respond_with @student, status: :unprocessable_entity
    end
  end

  # GET /students/1/download_document/:document_type
  def download_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]

    # Get the correct model attribute
    location = get_document_location document_type, @student

    extension = File.extname location

    if location and File.exists?(location)
      send_file location, :filename => "#{@student.last_name}_#{@student.first_name}_#{document_type}#{extension}"
    else
      head :no_content
    end
  end

  # GET /students/1/delete_document/:document_type
  def delete_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]

    # Get the correct model attribute
    location = get_document_location document_type, @student

    if location and File.exists?(location)
      FileUtils.rm(location)
      set_document_location document_type, @student, ''
      if @student.save
        respond_with @student
      else
        head :no_content
      end
    else
      head :no_content
    end
  end

  def get_document_location(document_type, student)
    location = ''
    case document_type
    when 'cv'
      location = student.cv_location
    when 'transcript'
      location = student.transcript_location
    when 'coveringletter'
      location = student.coveringletter_location
    end
    location
  end

  def set_document_location(document_type, student, location)
    case document_type
    when 'cv'
      @student.cv_location = location
    when 'transcript'
      @student.transcript_location = location
    when 'coveringletter'
      @student.coveringletter_location = location
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
