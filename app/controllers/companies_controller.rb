class CompaniesController < ApplicationController
  respond_to :json

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
    respond_with @companies
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = Company.find(params[:id])
    respond_with @company
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new

    respond_with @company
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(params[:company])

    if @company.save
      respond_with @company, status: :created, location: @company
    else
      respond_with @company, status: :unprocessable_entity
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    if @company.update_attributes(params[:company])
      respond_with @company
    else
      respond_with @company, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    
    head :no_content
  end

  # TODO: THis is repeated in the student controller
  # GET /students/1/:document_type
  def download_document
    @company = Company.find(params[:id])
    document_type = params[:document_type]
    document = (@company.send "#{document_type}".to_sym).path
    ext = File.extname document

    unless document.nil?
      send_file document, :filename => "#{@company.name}_#{document_type}#{ext}"
    else
      head :no_content
    end
  end

  # DELETE /students/1/:document_type
  def delete_document
    @company = Company.find(params[:id])
    document_type = params[:document_type]
    @company.send "#{document_type}=".to_sym, nil

    if @company.save
      respond_with @company
    else
      respond_with @company, status: :unprocessable_entity
    end
  end

end
