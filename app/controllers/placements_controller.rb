class PlacementsController < ApplicationController
  impressionist

  load_and_authorize_resource
  respond_to :json
  before_filter :require_login

  # Find all placements current_user has access to
  # If company_id is specified, only show that company's placements
  # If limit is specified, limit results
  # If student sort on relevance, then company id (groups by company if same relevance)
  #
  # GET /placements
  # GET /placements.json
  def index
    #@placements = Placements.all

    if params.keys.include? "company_id"
      @placements = @placements.where(:company_id => params[:company_id])
    end

    # if a deadline has been included, then only get items after this date
    if params.keys.include? "deadline"
      @placements = @placements.where("deadline > ?", DateTime.parse(params[:deadline]).to_formatted_s(:db))
    end

    if params.keys.include? "limit"
      @placements = @placements.limit(params[:limit])
    end

    if current_user && current_user.is_student?
      @placements = @placements.with_approved_state.select {|p| can? :show, p.company }
      @placements = @placements.sort_by {|p| [-p.relevance(current_user.id), p.company.name] }
      respond_with @placements.as_json({:student_id => current_user.id})
    elsif current_user && current_user.is_department_admin?
      respond_with @placements
    else
      respond_with @placements
    end
  end

  def pending
    @placements = Placement.with_new_state
    respond_with @placements
  end

  def email_approve
    @placement = Placement.find(params[:id])
    @companyAdmin = CompanyAdministrator.find_by_company_id(@placement.company_id)
    if !current_user.is_department_admin?
      redirect_to root_path
    elsif @placement.approved? or @placement.rejected?
      @status = @placement.current_state
      redirect_to "#{@url}/opportunities/#{@placement.id}", :notice => "Opportunity already " + "#{@status}"
    else
      if @placement.approve!
        UserMailer.approved_opportunity_email(@companyAdmin.email, @placement).deliver
        redirect_to "#{@url}/opportunities/#{@placement.id}", :notice => "Opportunity approved"
      else
        redirect_to "#{@url}/opportunities/#{@placement.id}", :notice => "Unprocessable entity"
      end
    end
  end

  def approve
    @placement = Placement.find(params[:id])
    @companyAdmin = CompanyAdministrator.find_by_company_id(@placement.company_id)
    if @placement.approve!
      UserMailer.approved_opportunity_email(@companyAdmin.email, @placement).deliver
      respond_with @placement
    else
      respond_with @placement, status: :unprocessable_entity
    end
  end

  def email_reject
    @placement = Placement.find(params[:id])
    @companyAdmin = CompanyAdministrator.find_by_company_id(@placement.company_id)
    if !current_user.is_department_admin?
      redirect_to root_path
    elsif @placement.approved? or @placement.rejected?
      @status = @placement.current_state
      redirect_to "#{@url}/opportunities/#{@placement.id}", :notice => "Opportunity already " + "#{@status}"
    else
      if @placement.reject!
        ### uncomment to send rejection notification email to company ###
        #UserMailer.rejected_opportunity_email(@companyAdmin.email, @placement).deliver
        redirect_to "#{@url}/opportunities/#{@placement.id}", :notice => "Opportunity rejected"
      else
        redirect_to "#{@url}/opportunities/#{@placement.id}", :notice => "Unprocessable entity"
      end
    end
  end

  def reject
    @placement = Placement.find(params[:id])
    @companyAdmin = CompanyAdministrator.find_by_company_id(@placement.company_id)
    if @placement.reject!
      ### uncomment to send rejection notification email to company ###
      #UserMailer.rejected_opportunity_email(@companyAdmin.email, @placement).deliver
      respond_with @placement
    else
      respond_with @placement, status: :unprocessable_entity
    end
  end

  # Find placement with specified id
  #
  # GET /placements/1
  # GET /placements/1.json
  def show
    @placement = Placement.find(params[:id])
    respond_with @placement.as_json
  end

  # Create new placement
  #
  # GET /placements/new
  # GET /placements/new.json
  def new
    @placement = Placement.new
    respond_with @placement
  end

  # Create new placement with given params
  #
  # POST /placements
  # POST /placements.json
  def create
    @placement = Placement.new(params[:placement])
    @admins = DepartmentAdministrator.all

    if @placement.save
      UserMailer.validate_placement_email("cpp@doc.ic.ac.uk", @placement).deliver
      respond_with @placement, status: :created, location: @placement
    else
      respond_with @placement, status: :unprocessable_entity
    end
  end

  # Update specified placement with params
  #
  # PUT /placements/1
  # PUT /placements/1.json
  def update
    @placement = Placement.find(params[:id])

    if @placement.update_attributes(params[:placement])
      head :no_content
    else
      respond_with @placement, status: :unprocessable_entity
    end
  end

  # Delete specified placement
  #
  # DELETE /placements/1
  # DELETE /placements/1.json
  def destroy
    @placement = Placement.find(params[:id])
    @placement.destroy
    head :no_content
  end

  # Return top five placements with the highest views in the given week
  #
  # GET /placements/top_5
  def top_5
    placement_impressions = Impression.where(
      "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
      1.weeks.ago.to_date.at_beginning_of_day,
      Date.today.tomorrow.at_beginning_of_day,
      'stat_show',
      'placements'
    )

    placement_ids = placement_impressions.map{ |si| si.impressionable_id }
    placement_id_counts = Hash.new(0)
    placement_ids.each{|si| placement_id_counts[si] += 1}
    placement_id_counts.sort_by {|key, value| value}

    # Order placement_id_counts by count
    sortable = placement_id_counts.map{|k, v| [v, k]}
    sortable.sort!.reverse!

    placements = sortable.map{ |count, id| Placement.find(id) }

    ok_placements = []
    placements.each do |s|
      if s.departments.map(&:id).include? current_user.department_id
        ok_placements.push(s)
      end
    end

    ok_placements.each { |s| s.stat_count = placement_id_counts[s.id] }

    respond_with ok_placements[0..4]
  end
end
