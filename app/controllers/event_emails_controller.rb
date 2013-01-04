class EventEmailsController < ApplicationController
  respond_to :json
  
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

  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = EventEmail.find(params[:id])
    respond_with @email
  end

  def preview
    @email = EventEmail.find(params[:id])
    render :text => @email.body
  end

  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = EventEmail.new
    respond_with @email
  end

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

  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = EventEmail.find(params[:id])
    if @email.update_attributes(params[:event_email])
      @email.send_email
      head :no_content
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  def get_matching_students_count
    @email = EventEmail.find(params[:id])
    respond_with @email.get_matching_students_count
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = EventEmail.find(params[:id])
    @email.destroy
    head :no_content
  end
end
