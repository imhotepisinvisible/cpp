class DepartmentAdministratorsController < ApplicationController
  impressionist

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
    @department_administrator = DepartmentAdministrator.find(params[:id])
    respond_with @department_administrator
  end

  # GET /department_administrators/new
  # GET /department_administrators/new.json
  def new
    @department_administrator = DepartmentAdministrator.new
    respond_with @department_administrator
  end

  # POST /department_administrators
  # POST /department_administrators.json
  def create
    @department_administrator = DepartmentAdministrator.new(params[:department_administrator])
    if @department_administrator.save
      respond_with @department_administrator, status: :created, location: @department_administrator
    else
      respond_with @department_administrator, status: :unprocessable_entity
    end
  end

  # PUT /department_administrators/1
  # PUT /department_administrators/1.json
  def update
    @department_administrator = DepartmentAdministrator.find(params[:id])
    if @department_administrator.update_attributes(params[:department_administrator])
      head :no_content
    else
      respond_with @department_administrator, status: :unprocessable_entity
    end
  end

  # DELETE /department_administrators/1
  # DELETE /department_administrators/1.json
  def destroy
    @department_administrator = DepartmentAdministrator.find(params[:id])
    @department_administrator.destroy
    head :no_content
  end
end
