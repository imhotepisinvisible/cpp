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

    new CPP.Views.Stats.LineGraph
      url: '/students/view_stats_all'
      title: 'Student Profile Views'
      type: 'datetime'
      yAxis: 'Views'
      el: '#student-chart'

    new CPP.Views.Stats.LineGraph
      url: '/companies/view_stats_all'
      title: 'Company Profile Views'
      type: 'datetime'
      yAxis: 'Views'
      el: '#companies-chart'