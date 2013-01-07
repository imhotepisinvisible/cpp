class EventsController < ApplicationController
  impressionist

  load_and_authorize_resource
  respond_to :json
  before_filter :require_login

  # GET /events
  # GET /events.json
  def index
    @events = current_user.events.scoped

    if params.keys.include? "company_id"
      @events = @events.where(:company_id => params[:company_id])
    end

    if params.keys.include? "limit"
      @events = @events.limit(params[:limit])
    end

    if current_user && current_user.is_student?
      # Sort on relevance, then company id (groups by company if same relevance)
      @events.sort_by! {|e| [-e.relevance(current_user.id), e.company.name] }
      respond_with @events.as_json({:student_id => current_user.id})
    else
      respond_with @events
    end
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

    if params.has_key? :departments
      departments = params[:departments].map{ |id| Department.find(id) }
    else
      departments = []
    end
    @event.departments = departments

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

  # PUT /events/1/register
  # PUT /events/1/register.json
  def register
    event = Event.find(params[:id])
    if event.capacity == event.registered_students.length
      respond_with event, status: :unprocessable_entity
    elsif event.registered_students << Student.find(params[:student_id])
      head :no_content
    else
      respond_with event, status: :unprocessable_entity
    end
  end


  # PUT /events/unregister
  # PUT /events/unregister.json
  def unregister
    event = Event.find(params[:id])
    student = Student.find(params[:student_id])
    if event.registered_students.delete(student)
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
