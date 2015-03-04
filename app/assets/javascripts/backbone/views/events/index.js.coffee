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
    columns = [
      {
        name: ''
        cell: 'select-row'
        headerCell: 'select-all'
      }
      {
        name: 'id'
        label: 'ID'
        editable: false
        cell: Backgrid.IntegerCell.extend(orderSeparator: '')
      }
      {
        name: 'company_name'
        label: 'Company'
        cell: 'string'
      }
      {
        name: 'title'
        label: 'Event'
        cell: 'string'
      }
      {
        name: 'start_date'
        label: 'Date'
        cell: 'date'
      }
      {
        name: 'location'
        label: 'Location'
        cell: 'string'
      }
      {
        name: 'spaces'
        label: 'Spaces'
        cell: 'integer'
      }
    ]
  
    $(@el).html(@template(events: @collection.fullCollection, editable: @editable))
    @renderEvents(@collection.fullCollection)
    grid = new (Backgrid.Grid)(
      columns: columns
      collection: @collection)
    # Render the grid and attach the root to your HTML document
    $example2 = $('#events-table')
    $example2.append grid.render().el
    # Initialize the paginator
    paginator = new (Backgrid.Extension.Paginator)(collection: @collection)
    # Render the paginator
    $example2.after paginator.render().el
    # Initialize a client-side filter to filter on the client
    # mode pageable collection's cache.
    #filter = new (Backgrid.Extension.ClientSideFilter)(
    #  collection: pageableTerritories
    #  fields: [ 'name' ])
    # Render the filter
    #$example2.before filter.render().el

    
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
