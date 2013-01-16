class EventsController < ApplicationController
  impressionist

  load_and_authorize_resource
  respond_to :json
  before_filter :require_login

  # Find all events the current user has access to
  # If company_id is specified, only find those company events
  # If limit is specified, limit results
  # If student sort on relevance, then company id (groups by company if same relevance)
  # If department, only return that department events
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
      @events.sort_by! {|e| [-e.relevance(current_user.id), e.company.name] }
      respond_with @events.as_json({:student_id => current_user.id})
    elsif current_user && current_user.is_department_admin?
      respond_with @events.select{ |e| e.departments.map(&:id).include? current_user.department_id }
    else
      respond_with @events
    end
  end

  # Get event for given id and respond with it in JSON form
  # Inserts a list 'depts' into the JSON with the IDs of departments which this
  # event is targetted at.
  #
  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    respond_with @event.as_json({:depts => @event.departments.map { |d| d.id }})
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
      @event.departments = params[:departments].map{ |id| Department.find(id) }
    else
      @event.departments = []
    end

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

    if params.has_key? :departments
      @event.departments = params[:departments].map{ |id| Department.find(id) }
    else
      @event.departments = []
    end

    @event.assign_attributes(params[:event])

    if @event.save
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

  def top_5
    event_impressions = Impression.where(
      "created_at > ? AND created_at < ? AND action_name = ? AND controller_name = ?",
      1.weeks.ago.to_date.at_beginning_of_day,
      Date.today.tomorrow.at_beginning_of_day,
      'stat_show',
      'events'
    )

    event_ids = event_impressions.map{ |si| si.impressionable_id }
    event_id_counts = Hash.new(0)
    event_ids.each{|si| event_id_counts[si] += 1}
    event_id_counts.sort_by {|key, value| value}

    # Order event_id_counts by count
    sortable = event_id_counts.map{|k, v| [v, k]}
    sortable.sort!.reverse!

    events = sortable.map{ |count, id| Event.find(id) }

    ok_events = []
    events.each do |s|
      if s.departments.map(&:id).include? current_user.department_id
        ok_events.push(s)
      end
    end

    ok_events.each { |s| s.stat_count = event_id_counts[s.id] }

    respond_with ok_events[0..4]
  end
end
