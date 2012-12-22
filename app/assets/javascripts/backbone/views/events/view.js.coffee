CPP.Views.Events ||= {}

class CPP.Views.Events.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/events/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    @
