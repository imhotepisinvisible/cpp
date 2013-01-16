class EventEmailsController < ApplicationController
  impressionist

  before_filter :require_login
  load_and_authorize_resource
  respond_to :json

  # Find all emails related to events
  # If company_id is specified, only find that companies events
  # If limit is specified, limit results 
  #
  # GET /emails
  # GET /emails.json
  def index
    @emails = EventEmail.scoped

    if params.keys.include? "company_id"
      @emails = @emails.where(:company_id => params[:company_id])
    end

    if params.keys.include? "limit"
      @emails = @emails.limit(params[:limit])
    end

    respond_with @emails
  end

  # Find given event email
  #
  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = EventEmail.find(params[:id])
    respond_with @email
  end

  # Preview email
  #
  # GET /emails/1/preview
  def preview
    @email = EventEmail.find(params[:id])
    render :text => @email.body
  end

  # Create new event email 
  #
  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = EventEmail.new
    respond_with @email
  end

  # Create new event email with given params and set as pending approval
  #
  # POST /emails
  # POST /emails.json
  def create
    @email = EventEmail.new(params[:event_email])
    @email.state = "Pending"
    if @email.save
      respond_with @email, status: :created, location: @email
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # Update events email with given params
  #
  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = EventEmail.find(params[:id])
    if @email.update_attributes(params[:event_email])
      head :no_content
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # Return number of students who will receive this email
  #
  # GET /emails/1/get_matching_students_count
  def get_matching_students_count
    @email = EventEmail.find(params[:id])
    respond_with @email.get_matching_students_count
  end

  # Delete event email 
  #
  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = EventEmail.find(params[:id])
    @email.destroy
    head :no_content
  end
end
