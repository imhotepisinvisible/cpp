class CPP.Views.CompaniesView extends CPP.Views.Base
  el: "#app"
  template: JST['companies/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      collection: @model.placements
    @
