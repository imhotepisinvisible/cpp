class DepartmentAdministratorsController < ApplicationController
  respond_to :json

  # GET /department_administrators
  # GET /department_administrators.json
  # GET /departments/1/department_administrators.json
  def index
    @department_admins = DepartmentAdministrator.scoped
    if params.keys.include? "department_id"
      respond_with @department_admins.where(:department_id => params[:department_id])
    else
      respond_with @department_admins
    end
  end

  # GET /department_administrators/1
  # GET /department_administrators/1.json
  def show
    @department = DepartmentAdministrator.find(params[:id])
    respond_with @department
  end

  # GET /department_administrators/new
  # GET /department_administrators/new.json
  def new
    @department = DepartmentAdministrator.new
    respond_with @department
  end

  # POST /department_administrators
  # POST /department_administrators.json
  def create
    @department = DepartmentAdministrator.new(params[:department_administrator])
    if @department.save
      respond_with @department, status: :created, location: @department
    else
      respond_with @department, status: :unprocessable_entity
    end
  end

  # PUT /department_administrators/1
  # PUT /department_administrators/1.json
  def update
    @department = DepartmentAdministrator.find(params[:id])
    if @department.update_attributes(params[:department_administrator])
      head :no_content
    else
      respond_with @department, status: :unprocessable_entity
    end
  end

  # DELETE /department_administrators/1
  # DELETE /department_administrators/1.json
  def destroy
    @department = DepartmentAdministrator.find(params[:id])
    @department.destroy
    head :no_content
  end
end
