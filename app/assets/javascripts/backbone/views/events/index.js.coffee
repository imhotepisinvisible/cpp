CPP.Views.Events ||= {}

class CPP.Views.Events.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/events/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .company-logo-header"      : "viewCompany"

  # Bind reset and filter events to render and renderEvents so that on change
  # the views change.
  initialize: ->
    # bind scrolling in the window to scrollevent
    _.bindAll this, 'scrollevent'
    $(window).scroll @scrollevent 
    
    #display ajax spinner whilst waiting for the collection to finish loading
    @collection.on "fetch", (->
    	@$('#events-table').append "<div class=\"loading\"></div>"
    	return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderEvents, @
    @editable = isAdmin()
    @render()

  addPage: ->
    if @collection.hasNextPage()
      @collection.getNextPage()
  @

  scrollevent: ->
    if $(window).scrollTop() + $(window).height() > $(document).height() - 20
      if @collection.hasNextPage()
        @collection.getNextPage()
  @ 

  # Render events
  render: ->
    $(@el).html(@template(events: @collection.fullCollection, editable: @editable))
    @renderEvents(@collection.fullCollection)
    @renderFilters()
    if $(document).height() <= $(window).height()
      @addPage()
  @

  # Render each event item
  renderEvents: (col) ->
    @$('#events').html("")
    col.each (event) =>
      view = new CPP.Views.Events.Item(model: event, editable: @editable)
      @$('#events').append(view.render().el)
    @

  # Create event filters
  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#event-filter')
      filters: [
        {name: "Tags"
        type: "tags"
        attribute: ["skill_list", "interest_list", "year_group_list"]
        scope: ''},
        {name: "Starting After",
        type: 'date',
        attribute: 'start_date'
        scope: ''},
        {name: "Company"
        type: "text"
        attribute: "company_name"
        scope: ''},
        {name: "Event Title",
        type: "text",
        attribute: 'title',
        scope: ''},
        {name: "Location"
        type: "text"
        attribute: "location"
        scope: ''},
      ]
      data: @collection.fullCollection
  @

  # Navigate to company page
  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
