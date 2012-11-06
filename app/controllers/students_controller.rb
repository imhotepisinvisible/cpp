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
    @student.profile = StudentProfiles.find(@student.profile_id)
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