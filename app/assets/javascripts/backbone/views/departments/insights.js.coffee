CPP.Views.Departments ||= {}

class CPP.Views.Departments.Insights extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/insights']

  # events: -> _.extend {}, CPP.Views.Base::events,
  #   'click .btn-submit': 'submit'

  initialize: ->
    $.get '/students/view_stats', (data) ->
      console.log data
    @render()

  render: ->
    $(@el).html(@template())