class OrganisationDomainsController < ApplicationController
  impressionist
  respond_to :json

  # GET /organisation_domains
  # GET /organisation_domains.json
  def index
    @organisation_domains = OrganisationDomain.all
    respond_with @organisation_domains
  end

  # GET /organisation_domains/1
  # GET /organisation_domains/1.json
  def show
    @organisation_domain = OrganisationDomain.find(params[:id])
    respond_with @organisation_domain
  end

  # GET /organisation_domains/new
  # GET /organisation_domains/new.json
  def new
    @organisation_domain = OrganisationDomain.new
    respond_with @organisation_domain
  end

  # POST /organisation_domains
  # POST /organisation_domains.json
  def create
    @organisation_domain = OrganisationDomain.new(params[:organisation_domain])
    if @organisation_domain.save
      respond_with @organisation_domain, status: :created, location: @organisation_domain
    else
      respond_with @organisation_domain, status: :unprocessable_entity
    end
  end

  # PUT /organisation_domains/1
  # PUT /organisation_domains/1.json
  def update
    @organisation_domain = OrganisationDomain.find(params[:id])
    if @organisation_domain.update_attributes(params[:organisation_domain])
      head :no_content
    else
      respond_with @organisation_domain, status: :unprocessable_entity
    end
  end

  # DELETE /organisation_domains/1
  # DELETE /organisation_domains/1.json
  def destroy
    @organisation_domain = OrganisationDomain.find(params[:id])
    @organisation_domain.destroy
    head :no_content
  end
end
