class CPP.Views.EventsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['events/index']

  events:
    'click .company-logo-header' : 'viewCompany'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    # bind to model destroy so backbone view updates on destroy
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template(events: @collection))

    @collection.each (event) =>
      event.company = new CPP.Models.Company id: event.get("company_id")
      event.company.fetch
        success: ->
          # Render the event if we can get its company
          view = new CPP.Views.EventsItem model: event
          @$('#events').append(view.render().el)
        error: ->
          notify "error", "Couldn't fetch company for event"
    @

  viewCompany: ->
    if @collection.company 
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
    