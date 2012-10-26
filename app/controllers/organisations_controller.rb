class OrganisationsController < ApplicationController
  # GET /organisations
  # GET /organisations.json
  def index
    @organisations = Organisation.all
    respond_with @organisations
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
    @organisation = Organisation.find(params[:id])
    respond_with @organisation
  end

  # GET /organisations/new
  # GET /organisations/new.json
  def new
    @organisation = Organisation.new
    respond_with @organisation
  end

  # POST /organisations
  # POST /organisations.json
  def create
    @organisation = Organisation.new(params[:organisation])
    if @organisation.save
      respond_with @organisation, status: :created, location: @organisation
    else
      respond_with @organisation.errors, status: :unprocessable_entity
    end
  end

  # PUT /organisations/1
  # PUT /organisations/1.json
  def update
    @organisation = Organisation.find(params[:id])
    if @organisation.update_attributes(params[:organisation])
      head :no_content
    else
      respond_with @organisation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    @organisation = Organisation.find(params[:id])
    @organisation.destroy
    head :no_content
  end
end
