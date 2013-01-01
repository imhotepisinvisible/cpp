class CompanyContactsController < ApplicationController
  respond_to :json

  # GET /company_contacts
  # GET /company_contacts.json
  def index
    @contacts = CompanyContact.scoped

    if params.keys.include? "company_id"
      @contacts = @contacts.where(:company_id => params[:company_id]).order('position ASC')
    end

    if params.keys.include? "limit"
      @contacts = @contacts.limit(params[:limit])
    end

    respond_with @contacts
  end

  # GET /company_contacts/1
  # GET /company_contacts/1.json
  def show
    @contact = CompanyContact.find(params[:id])
    respond_with @contact
  end

  # GET /company_contacts/new
  # GET /company_contacts/new.json
  def new
    @contact = CompanyContact.new
    respond_with @contact
  end

  # POST /company_contacts
  # POST /company_contacts.json
  def create
    @contact = CompanyContact.new(params[:company_contact])
    if @contact.save
      respond_with @contact, status: :created, location: @contact
    else
      respond_with @contact, status: :unprocessable_entity
    end
  end

  # PUT /company_contacts/1
  # PUT /company_contacts/1.json
  def update
    @contact = CompanyContact.find(params[:id])
    if @contact.update_attributes(params[:company_contact])
      head :no_content
    else
      respond_with @contact, status: :unprocessable_entity
    end
  end

  # DELETE /company_contacts/1
  # DELETE /company_contacts/1.json
  def destroy
    @contact = CompanyContact.find(params[:id])
    @contact.destroy
    head :no_content
  end
end
