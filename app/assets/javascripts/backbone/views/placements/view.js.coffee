CPP.Views.Placements ||= {}

class CPP.Views.Placements.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/placements/view']

  initialize: ->
    if isStudent()
      @model.record_stat_view()
    @render()

  render: ->
    $(@el).html(@template(placement: @model))
    $(@el).ready =>
      $("#jcountdown").setCountdown()
      #Date for the countdown
      targetDate: @model.get('deadline')
      itemLabels: ["D", "H", "M", "S"]
    @
