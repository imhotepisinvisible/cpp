class DirectEmailsController < ApplicationController
  impressionist

  before_filter :require_login
  load_and_authorize_resource
  respond_to :json


  # Returns direct emails,
  # If company_id is specified, finds just for that company
  # If limit is specified, limits results
  #
  # GET /emails
  # GET /emails.json
  def index
    @emails = DirectEmail.scoped

    if params.keys.include? "company_id"
      @emails = @emails.where(:company_id => params[:company_id])
    end

    if params.keys.include? "limit"
      @emails = @emails.limit(params[:limit])
    end

    respond_with @emails
  end

  # Get direct email for id 
  #
  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = DirectEmail.find(params[:id])
    respond_with @email
  end

  # Previews email body
  #
  # GET /emails/1/preview
  def preview
    @email = DirectEmail.find(params[:id])
    render :text => @email.body
  end

  # Create new direct email 
  #
  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = DirectEmail.new
    respond_with @email
  end

  # Create new email with params 
  #
  # POST /emails
  # POST /emails.json
  def create
    @email = DirectEmail.new(params[:direct_email])
    @email.state = "Approved"
    if params[:direct_email][:student_id]
      @email.student = Student.find(params[:direct_email][:student_id])
    end
    if @email.save
      respond_with @email, status: :created, location: @email
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # Update direct email with params 
  #
  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = DirectEmail.find(params[:id])
    if @email.update_attributes(params[:direct_email])
      head :no_content
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # Return number of students who the direct email will be sent to 
  #
  def get_matching_students_count
    @email = DirectEmail.find(params[:id])
    respond_with @email.get_matching_students_count
  end

  # Delete direct email 
  #
  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = DirectEmail.find(params[:id])
    @email.destroy
    head :no_content
  end
end
