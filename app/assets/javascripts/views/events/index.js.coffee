class CPP.Views.EventsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['events/index']

  events:
    "click .btn-add"                  : "addEvent"
    "click .company-logo-header"      : "viewCompany"


  initialize: ->
    @collection.each (model) ->
      model.set "visible", true
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderEvents, @
    # bind to model destroy so backbone view updates on destroy
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template(events: @collection))
    @renderEvents()
    @renderFilters()
  @

  renderEvents: ->
    @$('#events').html("")
    @collection.each (event) =>
      if (event.get "visible")
        event.company = new CPP.Models.Company id: event.get("company_id")
        event.company.fetch
          success: ->
            # Render the event if we can get its company
            view = new CPP.Views.EventsItem model: event
            @$('#events').append(view.render().el)
          error: ->
            notify "error", "Couldn't fetch company for event"
  @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#event-filter')
      filters: [
        {name: "Capacity Search"
        type: "text"
        attribute: "location"
        scope: "company"}
      ]
      data: @collection
  @ 
    
  addEvent: ->
    Backbone.history.navigate("companies/" + @collection.company.id + "/events/new", trigger: true)

  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
