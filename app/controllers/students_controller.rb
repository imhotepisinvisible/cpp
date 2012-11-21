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

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    params[:skill_list] = params[:skills].map{|t| t["name"]} if params.has_key? "skills"
    params[:year_groups] = params[:year_groups].map{|t| t["name"]} if params.has_key? "year_groups"
    params[:interests] = params[:interests].map{|t| t["name"]} if params.has_key? "interests"

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

  # GET /students/1/:document_type
  def download_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]
    document = (@student.send "#{document_type}".to_sym).path
    ext = File.extname document

    unless document.nil?
      send_file document, :filename => "#{@student.last_name}_#{@student.first_name}_#{document_type}#{ext}"
    else
      head :no_content
    end
  end

  # DELETE /students/1/:document_type
  def delete_document
    @student = Student.find(params[:id])
    document_type = params[:document_type]
    @student.send "#{document_type}=".to_sym, nil

    puts @student.inspect
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
        logger.info student.degree
        degrees.push student.degree
      end
    end
    respond_with degrees
  end
end
