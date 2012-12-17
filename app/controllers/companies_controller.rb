class CompaniesController < ApplicationController
  respond_to :json

  # If the current user is a student, injects their company preferences into
  # the company models as 'rating' else just returns all companies as JSON.
  #
  # TODO: This should only return companies the current student has access to
  #      via their department(s)
  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
    if current_user && current_user.type == "Student"
      respond_with @companies.as_json({:student_id => current_user.id})
    else
      respond_with @companies
    end
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

  # TODO: This is repeated in the student controller
  # TODO: User variable to symbol is BAD. Filter allowed doctypes
  # GET /students/1/:document_type
  def download_document
    company = Company.find(params[:id])
    document_type = params[:document_type]
    document_path = (company.send "#{document_type}".to_sym).path

    unless document_path.nil?
      document_extension = File.extname document_path
      new_doc_name = "#{company.name}_#{document_type}#{document_extension}"
      send_file document_path, :filename => new_doc_name
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

  # POST /companies/1/set_rating
  def set_rating
    if !current_user
      raise "MUST BE LOGGED IN"
    end
    student_id = current_user.id
    company_id = params[:id]
    student_company_rating = StudentCompanyRating.find_or_create_by_student_id_and_company_id(student_id, company_id)
    student_company_rating.rating = params[:rating]
    student_company_rating.save!

    head :no_content
  end

end
