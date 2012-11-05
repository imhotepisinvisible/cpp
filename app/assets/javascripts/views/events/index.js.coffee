class CPP.Views.EventsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['events/index']

  events:
    "click .btn-add"                  : "addEvent"
    "click .company-logo-header"      : "viewCompany"
    "click .search-btn"         : "search"


  initialize: ->
    @collection.each (model) ->
      model.set "visible", true
    @collection.bind 'reset', @render, @
    # bind to model destroy so backbone view updates on destroy
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template(events: @collection))

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

  addEvent: ->
    Backbone.history.navigate("companies/" + @collection.company.id + "/events/new", trigger: true)

  viewCompany: ->
    if @collection.company 
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
    
  search: ->
    @collection.each (model) ->
      model.set "visible", false
      console.log model
      for k,v of model.company.attributes
        if (model.company.get k) == $("#search-input").val()
          model.set "visible", true
          break
    @render()