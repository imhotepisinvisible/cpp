class CPP.Views.CompaniesView extends Backbone.View
  el: "#app"
  template: JST['companies/view']
    

  initialize: ->
    #@model.bind 'change', @render, @
    # _.bindAll @, 'render'
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      collection: @model.placements
    @

  log: ->
    console.log "logging!!"
