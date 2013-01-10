class PlacementsController < ApplicationController
  impressionist

  load_and_authorize_resource
  respond_to :json
  before_filter :require_login

  # GET /placements
  # GET /placements.json
  def index
    @placements = current_user.placements.scoped

    if params.keys.include? "company_id"
      @placements = @placements.where(:company_id => params[:company_id])
    end

    if params.keys.include? "limit"
      @placements = @placements.limit(params[:limit])
    end

    if current_user && current_user.is_student?
      # Sort on relevance, then company id (groups by company if same relevance)
      @placements = @placements.sort_by {|p| [-p.relevance(current_user.id), p.company.name] }
      respond_with @placements.as_json({:student_id => current_user.id})
    else
      respond_with @placements
    end
  end

  # GET /placements/1
  # GET /placements/1.json
  def show
    @placement = Placement.find(params[:id])
    respond_with @placement
  end

  # GET /placements/new
  # GET /placements/new.json
  def new
    @placement = Placement.new
    respond_with @placement
  end

  # POST /placements
  # POST /placements.json
  def create
    @placement = Placement.new(params[:placement])

    if @placement.save
      respond_with @placement, status: :created, location: @placement
    else
      respond_with @placement, status: :unprocessable_entity
    end
  end

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

  # DELETE /placements/1
  # DELETE /placements/1.json
  def destroy
    @placement = Placement.find(params[:id])
    @placement.destroy
    head :no_content
  end

  def top_5
    # TODO student profile views should be cached
    placement_impressions = Impression.where(
      "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
      1.weeks.ago.to_date.at_beginning_of_day,
      Date.today.tomorrow.at_beginning_of_day,
      'stat_show',
      'placements'
    )

    #raise student_impressions.first.inspect
    placement_ids = placement_impressions.map{ |si| si.impressionable_id }
    placement_id_counts = Hash.new(0)
    placement_ids.each{|si| placement_id_counts[si] += 1}
    placement_id_counts.sort_by {|key, value| value}
    # ORDER student_id_counts by count
    sortable = placement_id_counts.map{|k, v| [v, k]}
    sortable.sort!.reverse!

    placements = sortable.map{ |count, id| Placement.find(id) }

    ok_placements = []
    placements.each do |s|
      if s.company.all_departments.map(&:id).include? current_user.department_id
        ok_placements.push(s)
      end
    end

    ok_placements.each { |s| s.stat_count = placement_id_counts[s.id] }

    respond_with ok_placements[0..4]
  end
end
