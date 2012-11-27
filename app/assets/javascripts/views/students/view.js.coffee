class CPP.Views.StudentsView extends CPP.Views.Base
  el: "#app"
  template: JST['students/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(student: @model))
    super

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements
    @
