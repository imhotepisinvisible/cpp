class DepartmentsController < ApplicationController
  respond_to :json

  # GET /departments
  # GET /departments.json
  def index
    if params.keys.include? "company_id"
      @departments = @departments.all(:include => :companies, :conditions => ["companies.id = ?", params[:company_id]])
    else
      @departments = Department.all
    end
    respond_with @departments
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    respond_with @department
  end

  # GET /departments/new
  # GET /departments/new.json
  def new
    @department = Department.new
    respond_with @department
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(params[:department])
    if @department.save
      respond_with @department, status: :created, location: @department
    else
      respond_with @department, status: :unprocessable_entity
    end
  end

  # PUT /departments/1
  # PUT /departments/1.json
  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      head :no_content
    else
      respond_with @department, status: :unprocessable_entity
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    head :no_content
  end
end
