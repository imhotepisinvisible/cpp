class CPP.Views.CompaniesEdit extends Backbone.View
  el: "#app"
  template: JST['companies/edit']
    

  initialize: ->
    #@model.bind 'change', @render, @
    # _.bindAll @, 'render'
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    events = new CPP.Collections.Events
    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      collection: events
    events.fetch()

    @

  log: ->
    console.log "logging!!"
