class PlacementsController < ApplicationController
  respond_to :json

  # GET /placements
  # GET /placements.json
  def index
    if params.keys.include? "company_id"
      @placements = Placement.find_all_by_company_id(params[:company_id], :limit => 3)
    else
      @placements = Placement.all
    end

    respond_with @placements
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
      respond_with @placement.errors, status: :unprocessable_entity
    end
  end

  # PUT /placements/1
  # PUT /placements/1.json
  def update
    @placement = Placement.find(params[:id])

    if @placement.update_attributes(params[:placement])
      head :no_content
    else
      respond_with @placement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /placements/1
  # DELETE /placements/1.json
  def destroy
    @placement = Placement.find(params[:id])
    @placement.destroy
    head :no_content
  end
end