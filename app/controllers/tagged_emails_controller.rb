class TaggedEmailsController < ApplicationController
  impressionist
  
  before_filter :require_login
  load_and_authorize_resource
  respond_to :json
  
  # Get all tagged emails
  # If company_id specified, only find for that company
  # If limit specified, limit results
  #
  # GET /emails
  # GET /emails.json
  def index
    @emails = TaggedEmail.scoped

    if params.keys.include? "company_id"
      @emails = @emails.where(:company_id => params[:company_id])
    end

    if params.keys.include? "limit"
      @emails = @emails.limit(params[:limit])
    end

    respond_with @emails
  end

  # Return specified TaggedEmail
  #
  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = TaggedEmail.find(params[:id])
    respond_with @email
  end

  # Preview specified email
  #
  def preview
    @email = TaggedEmail.find(params[:id])
    render :text => @email.body
  end

  # Create new TaggedEmail
  #
  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = TaggedEmail.new
    respond_with @email
  end

  # Create new TaggedEmail with given params and set its approval to pending
  #
  # POST /emails
  # POST /emails.json
  def create
    @email = TaggedEmail.new(params[:tagged_email])
    @email.state = "Pending"
    if @email.save
      respond_with @email, status: :created, location: @email
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # Update specified tagged email with given params
  #
  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = TaggedEmail.find(params[:id])
    if @email.update_attributes(params[:tagged_email])
      head :no_content
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # Return number of students who will receive this email
  #
  # GET /emails/1/get_matching_students_count 
  def get_matching_students_count
    @email = TaggedEmail.find(params[:id])
    respond_with @email.get_matching_students_count
  end

  # Delete specified TaggedEmail
  #
  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = TaggedEmail.find(params[:id])
    @email.destroy
    head :no_content
  end
end
