class CPP.Views.PlacementsView extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/placements/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(placement: @model))
    $(@el).ready =>
      $("#jcountdown").setCountdown()
      #Date for the countdown
      targetDate: @model.attributes.deadline
      itemLabels: ["D", "H", "M", "S"]
    @
