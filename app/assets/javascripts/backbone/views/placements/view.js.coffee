CPP.Views.Placements ||= {}

# Placement view
class CPP.Views.Placements.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/placements/view']

  # If current user is a student then record view of placement
  initialize: ->
    if isStudent()
      @model.record_stat_view()
    @render()

  # Render placement template with placement model
  render: ->
    $(@el).html(@template(placement: @model))
    @
