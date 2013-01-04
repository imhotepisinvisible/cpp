class DepartmentsController < ApplicationController
  respond_to :json

  # GET /departments
  # GET /departments.json
  # GET /companies/1/departments.json
  def index
    if params.keys.include? "company_id"
      company = Company.find(params[:company_id])
      respond_with company.all_departments.as_json({:company_id => params[:company_id]})
    else
      respond_with Department.all
    end
  end

  # PUT /companies/1/departments/1/change_status
  def change_status
    raise unless params.has_key? :company_id
    raise unless params.has_key? :status
    dept_reg = DepartmentRegistration.find_or_create_by_company_id_and_department_id(params[:company_id], params[:department_id])
    dept_reg.status = params[:status]
    if dept_reg.save
      head :no_content
    else
      respond_with dept_reg, status: :unprocessable_entity
    end
  end

  # PUT /companies/1/departments/1/apply
  def apply
    raise unless params.has_key? :company_id
    dept_reg = DepartmentRegistration.find_or_create_by_company_id_and_department_id(params[:company_id], params[:department_id])
    dept_reg.status = 1
    if dept_reg.save
      head :no_content
    else
      respond_with dept_reg, status: :unprocessable_entity
    end
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
