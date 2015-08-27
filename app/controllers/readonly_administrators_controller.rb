class ReadonlyAdministratorsController < ApplicationController
  impressionist

  load_and_authorize_resource

  respond_to :json

  # Return readonly admins
  # If department_id is specified, return only those of department
  #
  # GET /readonly_administrators
  # GET /readonly_administrators.json
  # GET /departments/1/readonly_administrators.json
  def index
    @readonly_admins = ReadonlyAdministrator.scoped
    if params.keys.include? "department_id"
      respond_with @readonly_admins.where(:department_id => params[:department_id])
    else
      respond_with @readonly_admins
    end
  end

  # Find readonly admin for given id
  #
  # GET /readonly_administrators/1
  # GET /readonly_administrators/1.json
  def show
    @readonly_administrator = ReadonlyAdministrator.find(params[:id])
    respond_with @readonly_administrator
  end

  # Create new readonly admin
  #
  # GET /readonly_administrators/new
  # GET /readonly_administrators/new.json
  def new
    @readonly_administrator = ReadonlyAdministrator.new
    respond_with @readonly_administrator
  end

  # Create new readonly admin with given params
  #
  # POST /readonly_administrators
  # POST /readonly_administrators.json
  def create
    @readonly_administrator = ReadonlyAdministrator.new(params[:readonly_administrator])
    if @readonly_administrator.save
      respond_with @readonly_administrator, status: :created, location: @readonly_administrator
    else
      respond_with @readonly_administrator, status: :unprocessable_entity
    end
  end

  # Update readonly admin with given params for given id
  #
  # PUT /readonly_administrators/1
  # PUT /readonly_administrators/1.json
  def update
    @readonly_administrator = ReadonlyAdministrator.find(params[:id])
    if @readonly_administrator.update_attributes(params[:readonly_administrator])
      head :no_content
    else
      respond_with @readonly_administrator, status: :unprocessable_entity
    end
  end

  # Delete readonly admin with given id
  #
  # DELETE /readonly_administrators/1
  # DELETE /readonly_administrators/1.json
  def destroy
    @readonly_administrator = ReadonlyAdministrator.find(params[:id])
    @readonly_administrator.destroy
    head :no_content
  end
end
