class DirectEmailsController < ApplicationController
  impressionist

  respond_to :json

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

  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = DirectEmail.find(params[:id])
    respond_with @email
  end

  def preview
    @email = DirectEmail.find(params[:id])
    render :text => @email.body
  end

  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = DirectEmail.new
    respond_with @email
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = DirectEmail.new(params[:direct_email])
    @email.state = "Pending"
    if params[:direct_email][:student_id]
      @email.student = Student.find(params[:direct_email][:student_id])
    end
    if @email.save
      respond_with @email, status: :created, location: @email
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

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

  def get_matching_students_count
    @email = DirectEmail.find(params[:id])
    respond_with @email.get_matching_students_count
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = DirectEmail.find(params[:id])
    @email.destroy
    head :no_content
  end
end
