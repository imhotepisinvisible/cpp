require 'cpp_approval_status'

class DepartmentsController < ApplicationController
  include CPPApprovalStatus
  impressionist

  respond_to :json

  # GET /departments
  # GET /departments.json
  # GET /companies/1/departments.json
  def index
    if params.keys.include? "company_id"
      company = Company.find(params[:company_id])
      respond_with Department.all.as_json({:company_id => params[:company_id]})
    else
      respond_with Department.all
    end
  end

  # Returns approval status for company
  #
  # GET /companies/1/departments/1/status
  def get_status
    raise unless params.has_key? :company_id
    dept_reg = DepartmentRegistration.find_or_create_by_company_id_and_department_id(params[:company_id], params[:department_id])

    respond_with dept_reg.status
  end

  # Sets approval status for company
  #
  # PUT /companies/1/departments/1/status
  def set_status
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
    dept_reg.status = CPPApprovalStatus.PENDING
    if dept_reg.save
      head :no_content
    else
      respond_with dept_reg, status: :unprocessable_entity
    end
  end

  # Finds department with given id
  #
  # GET /departments/1
  # GET /departments/1.json
  def show
    @department = Department.find(params[:id])
    respond_with @department
  end

  # Creates new department
  #
  # GET /departments/new
  # GET /departments/new.json
  def new
    @department = Department.new
    respond_with @department
  end

  # Creates new department with given params
  #
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

  # Updates department with given params
  #
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

  # Deletes department
  #
  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    head :no_content
  end
end
