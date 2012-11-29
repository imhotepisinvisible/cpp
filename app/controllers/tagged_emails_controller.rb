class TaggedEmailsController < ApplicationController
  respond_to :json
  
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

  # GET /emails/1
  # GET /emails/1.json
  def show
    @email = TaggedEmail.find(params[:id])
    puts "hello"
    puts @email.inspect
    respond_with @email

  end

  def preview
    @email = TaggedEmail.find(params[:id])
    render :text => @email.body
  end

  # GET /emails/new
  # GET /emails/new.json
  def new
    @email = TaggedEmail.new
    respond_with @email
  end

  # POST /emails
  # POST /emails.json
  def create
    @email = TaggedEmail.new(params[:email])
    puts @email.inspect
    if @email.save
      respond_with @email, status: :created, location: @email
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # PUT /emails/1
  # PUT /emails/1.json
  def update
    @email = TaggedEmail.find(params[:id])
    puts "%%%%%%%%%%%%%%%%%%%%%"
    puts @email.valid?
    puts @email.errors.inspect
    if @email.update_attributes(params[:tagged_email])
      puts @email.inspect
      @email.send_email
      head :no_content
    else
      respond_with @email, status: :unprocessable_entity
    end
  end

  # DELETE /emails/1
  # DELETE /emails/1.json
  def destroy
    @email = TaggedEmail.find(params[:id])
    @email.destroy
    head :no_content
  end
end
