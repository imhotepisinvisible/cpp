CPP.Views.Events ||= {}

class CPP.Views.Events.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/events/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .company-logo-header"      : "viewCompany"
    "click"                           : "addPage"

  # Bind reset and filter events to render and renderEvents so that on change
  # the views change.
  initialize: ->
    #@collection.on "fetch", (->
    #	@$('#events-table').html "<div class=\"loading\"></div>"
    #	return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderEvents, @
    @editable = isAdmin()
    @render()

  addPage: ->
    @collection.getNextPage({remove: false})
    console.log(@collection)
  @

  # Render events
  render: ->
    $(@el).html(@template(events: @collection, editable: @editable))
    @renderEvents(@collection)
    @renderFilters()
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
      data: @collection
  @

  # Navigate to company page
  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
