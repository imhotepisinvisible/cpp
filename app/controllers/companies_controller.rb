require 'json'

class CompaniesController < ApplicationController
  load_and_authorize_resource
  #before_filter :require_login
  respond_to :json

  # If the current user is a student, injects their company preferences into
  # the company models as 'rating' else just returns all companies as JSON.
  #
  # TODO: This should only return companies the current student has access to
  #      via their department(s)
  # GET /companies
  # GET /companies.json
  def index
    if current_user.is_student?
      respond_with current_user.companies.as_json({:student_id => current_user.id})
    elsif
      respond_with current_user.companies
    end
  end

  # GET departments/1/companies/pending
  def pending
    department = Department.find(params[:department_id])
    respond_with department.pending_companies
  end

  # PUT departments/1/companies/1/approve
  def approve
    department_registration = DepartmentRegistration.find_by_department_id_and_company_id(params[:department_id], params[:company_id])
    department_registration.approved = true
    department_registration.save!
  end

  # PUT departments/1/companies/1/reject
  def reject
    department_registration = DepartmentRegistration.find_by_department_id_and_company_id(params[:department_id], params[:company_id])
    department_registration.approved = false
    department_registration.save!
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    if current_user.is_student?
      # Inject company rating if the current user is a student
      respond_with current_user.companies.find(params[:id]).as_json({:student_id => current_user.id})
    else
      @company = Company.find(params[:id])
      respond_with @company
    end
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
    if current_user
      @company.organisation_id = current_user.organisation.id
    else
      @company.organisation_id = 1
    end

    if params.has_key? :departments
      departments = params[:departments].map{ |id| Department.find(id) }
    else
      departments = []
    end
    @company.pending_departments = departments

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
      if Rails.env.production?
        redirect_to "https://s3-eu-west-1.amazonaws.com/imperial-cpp#{(company.send "#{document_type}".to_sym).path}"
        return
      end

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

  def view_stats
    @company = Company.find(params[:id])
    data = {
      :name => "Company Views",
      :pointInterval => 1.day * 1000,
      :pointStart => 1.weeks.ago.at_midnight.to_i * 1000,
      :data => (1.weeks.ago.to_date..Date.today).map{ |date|
        @company.impressions.where(
          "created_at > ? AND created_at < ?",
          date.at_beginning_of_day,
          date.tomorrow.at_beginning_of_day
        ).select{ |impression| impression.action_name == "stat_show"}.count
      }
    }
    respond_with data
  end

end
