class CoursesController < ApplicationController

  load_and_authorize_resource
  respond_to :json
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
    respond_with @courses
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    respond_with @courses
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new
    respond_with @course
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

      if @course.save
        respond_with @course, status: :created, location: @course
      else
        respond_with @course, status: :unprocessable_entity
      end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    if @course.update_attributes(params[:course])
      respond_with @course
    else
      respond_with @course, status: :unprocessable_entity
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    head :no_content
  end
end
