class CPP.Views.PlacementsView extends CPP.Views.Base
  el: "#app"
  template: JST['placements/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(placement: @model))
    @
