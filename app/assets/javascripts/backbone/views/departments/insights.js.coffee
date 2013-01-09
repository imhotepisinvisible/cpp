CPP.Views.Departments ||= {}

class CPP.Views.Departments.Insights extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/insights']

  # events: -> _.extend {}, CPP.Views.Base::events,
  #   'click .btn-submit': 'submit'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template())