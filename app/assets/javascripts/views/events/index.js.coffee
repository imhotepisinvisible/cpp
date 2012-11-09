class CPP.Views.EventsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['events/index']

  events:
    "click .btn-add"                  : "addEvent"
    "click .company-logo-header"      : "viewCompany"


  initialize: ->
    #@collection.each (model) ->
      #model.set "visible", true
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderEvents, @
    # Bind to model destroy so backbone view updates on destroy
    @collection.bind 'destroy', @render, @
    
    # Get company for each event
    #x=0
    #eventCounter = 0
    #@collection.each (event) =>
      #if (event.get "visible")
    #console.log eventCounter
    #continue until (eventCounter == @collection.length)
    #console.log @collection.length
    @render()

  render: ->
    $(@el).html(@template(events: @collection))
    @collection.each (event) =>
      event.company = new CPP.Models.Company id: event.get("company_id")
      event.company.fetch
        success: ->
          #@allComplaniesFetched
          view = new CPP.Views.EventsItem model: event
          @$('#events').append(view.render().el)
        error: ->
          notify "error", "Couldn't fetch company for event"
    @renderFilters()
  @

  #allComplaniesFetched:
  #  _.after(3, =>
  #    @renderEvents()
  #    @renderFilters())

  renderEvents: (col) ->
    @$('#events').html("")
    col.each (event) ->
      view = new CPP.Views.EventsItem model: event
      @$('#events').append(view.render().el)
  @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#event-filter')
      filters: [
        {name: "Capacity Search"
        type: "number"
        attribute: "capacity"
        scope: ""},
        {name: "Location Search"
        type: "text"
        attribute: "location"
        scope: ""},
        {name: "Company"
        type: "tags"
        attribute: "name"
        scope: ".company"
        }
      ]
      data: @collection
  @ 
    
  addEvent: ->
    Backbone.history.navigate("companies/" + @collection.company.id + "/events/new", trigger: true)

  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
