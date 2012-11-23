class EventsController < ApplicationController
  respond_to :json

  # GET /events
  # GET /events.json
  def index
    @events = Event.scoped

    if params.keys.include? "company_id"
      @events = @events.where(:company_id => params[:company_id])
    end

    if params.keys.include? "limit"
      @events = @events.limit(params[:limit])
    end

    respond_with @events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    respond_with @event
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new
    respond_with @event
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    if @event.save
      respond_with @event, status: :created, location: @event
    else
      respond_with @event, status: :unprocessable_entity
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      head :no_content
    else
      respond_with @event, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    head :no_content
  end
end
