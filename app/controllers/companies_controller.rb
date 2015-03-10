require 'json'

class CompaniesController < ApplicationController
  impressionist
  load_and_authorize_resource
  respond_to :json

  # If the current user is a student, injects their company preferences into
  # the company models as 'rating' else just returns all companies as JSON.
  #
  # GET /companies
  # GET /companies.json
  def index
    if current_user.is_student?
      @companies = Company.where(:reg_status => [2,3])
      respond_with @companies.as_json({:student_id => current_user.id})
    elsif
      respond_with Company.all
    end
  end

  # Get companies pending for given department
  #
  # GET departments/1/companies/pending
  def pending
    @companies = Company.where(:reg_status => 1)
    respond_with @companies
  end

  # Approve company for given department
  #
  # PUT departments/1/companies/1/approve
  def approve
    @company = Company.find(params[:id])
    if @company.approve!
      respond_with @company
    else
      respond_with @company, status: :unprocessable_entity
    end
  end

  # Reject company for given department
  #
  # PUT departments/1/companies/1/reject
  def reject
    @company = Company.find(params[:id])
    if @company.reject!
      respond_with @company
    else
      respond_with @company, status: :unprocessable_entity
    end
  end

  # Show company
  #
  # Injects company rating if the current user is a student
  # GET /companies/1
  # GET /companies/1.json
  def show
    if current_user.is_student?
      respond_with current_user.companies.find(params[:id]).as_json({:student_id => current_user.id})
    else
      @company = Company.find(params[:id])
      respond_with @company
    end
  end

  # Create new company
  #
  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new
    respond_with @company
  end

  # Create new company with given params
  #
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

  # Update company based on params
  #
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

  # Deletes company and notifies deletion of administrator attached to account
  #
  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company_administrators = CompanyAdministrator.where(:company_id => @company.id)
    @company_administrators.each do |admin|
      UserMailer.account_terminated(admin).deliver
    end
    @company.destroy

    head :no_content
  end

  # Delete company logo
  #
  # DELETE /companies/1/delete_logo
  def delete_logo
    @company = Company.find(params[:id])
    @company.logo = nil

    if @company.save
      respond_with @company
    else
      respond_with @company, status: :unprocessable_entity
    end
  end

  # Set company rating
  #
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

  # Return student views for company over past week
  #
  # GET /companies/1/view_stats
  def view_stats
    @company = Company.find(params[:id])
    data = {
      :name => "Student Views",
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

  # Return student views for all companies from all time
  #
  # GET /companies/view_stats_all
  def view_stats_all
    data = {
      :name => "Company Views",
      :pointInterval => 1.day * 1000,
      :pointStart => 1.weeks.ago.at_midnight.to_i * 1000,
      :data => (1.weeks.ago.to_date..Date.today).map{ |date|
        Impression.where(
          "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
          date.at_beginning_of_day,
          date.tomorrow.at_beginning_of_day,
          'stat_show',
          'companies'
        ).select{ |impression| impression.action_name == "stat_show"}.count
      }
    }
    respond_with data
  end

  # Return top five companies
  #
  # GET /companies/top_5
  def top_5
    company_impressions = Impression.where(
      "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
      1.weeks.ago.to_date.at_beginning_of_day,
      Date.today.tomorrow.at_beginning_of_day,
      'stat_show',
      'companies'
    )

    company_ids = company_impressions.map{ |si| si.impressionable_id }
    company_id_counts = Hash.new(0)
    company_ids.each{|si| company_id_counts[si] += 1}
    company_id_counts.sort_by {|key, value| value}

    # Order company_id_counts by count
    sortable = company_id_counts.map{|k, v| [v, k]}
    sortable.sort!.reverse!

    companies = sortable.map{ |count, id| Company.find(id) }

    ok_companies = []
    companies.each do |s|
      if s.all_departments.map(&:id).include? current_user.department_id
        ok_companies.push(s)
      end
    end

    ok_companies.each { |s| s.stat_count = company_id_counts[s.id] }

    respond_with ok_companies[0..4]
  end
end
