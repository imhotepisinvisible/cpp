class CompanyAdministratorsController < ApplicationController
  # load_and_authorize_resource #TODO: Turn me on at some point
  respond_to :json

  # GET /company_administrators
  # GET /company_administrators.json
  def index
    @company_administrators = CompanyAdministrator.where(:active => true)
    respond_with @company_administrators
  end

  # GET /company_administrators/1
  # GET /company_administrators/1.json
  def show
    @company_administrator = CompanyAdministrator.find(params[:id])
    respond_with @company_administrator
  end

  # GET /company_administrators/new
  # GET /company_administrators/new.json
  def new
    @company_administrator = CompanyAdministrator.new
    respond_with @company_administrator
  end

  # POST /company_administrators
  # POST /company_administrators.json
  def create
    @company_administrator = CompanyAdministrator.new(params[:company_administrator])

    if @company_administrator.save
      respond_with @company_administrator, status: :created, location: @company_administrator
    else
      respond_with @company_administrator, status: :unprocessable_entity
    end
  end

  # PUT /company_administrators/1
  # PUT /company_administrators/1.json
  def update
    @company_administrator = CompanyAdministrator.find(params[:id])
    if @company_administrator.update_attributes(params[:company_administrator])
      respond_with @company_administrator, location: @company_administrator
    else
      respond_with @company_administrator, status: :unprocessable_entity
    end
  end

  # DELETE /company_administrators/1
  # DELETE /company_administrators/1.json
  def destroy
    @company_administrator = CompanyAdministrator.find(params[:id])
    @company_administrator.destroy!
    head :no_content
  end
end
