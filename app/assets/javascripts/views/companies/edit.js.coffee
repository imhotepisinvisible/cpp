class CPP.Views.CompaniesEdit extends Backbone.View
  el: "#app"
  template: JST['companies/edit']
    

  initialize: ->
    #@model.bind 'change', @render, @
    # _.bindAll @, 'render'
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      collection: @model.events
    @

  log: ->
    console.log "logging!!"
