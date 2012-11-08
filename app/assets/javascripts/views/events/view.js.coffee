class CPP.Views.EventsView extends CPP.Views.Base
  el: "#app"
  template: JST['events/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    @
