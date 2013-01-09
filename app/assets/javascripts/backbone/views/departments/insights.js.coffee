CPP.Views.DepartmentAdministrator ||= {}

class CPP.Views.DepartmentAdministrator.Insights extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/insights']

  # events: -> _.extend {}, CPP.Views.Base::events,
  #   'click .btn-submit': 'submit'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template())