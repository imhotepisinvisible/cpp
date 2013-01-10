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

    topCompanies = new CPP.Collections.Companies
    topCompanies.url = '/companies/top_5'
    topCompanies.fetch
      success: =>
        new CPP.Views.Stats.TopPartial
          el: $(@el).find('#top-companies')
          collection: topCompanies
          itemTemplate: JST['backbone/templates/stats/top_company']

    topStudents = new CPP.Collections.Students
    topStudents.url = '/students/top_5'
    topStudents.fetch
      success: =>
        new CPP.Views.Stats.TopPartial
          el: $(@el).find('#top-students')
          collection: topStudents
          itemTemplate: JST['backbone/templates/stats/top_student']

    topEvents = new CPP.Collections.Events
    topEvents.url = '/events/top_5'
    topEvents.fetch
      success: =>
        new CPP.Views.Stats.TopPartial
          el: $(@el).find('#top-events')
          collection: topEvents
          itemTemplate: JST['backbone/templates/stats/top_event']

    topPlacements = new CPP.Collections.Students
    topPlacements.url = '/placements/top_5'
    topPlacements.fetch
      success: =>
        new CPP.Views.Stats.TopPartial
          el: $(@el).find('#top-placements')
          collection: topPlacements
          itemTemplate: JST['backbone/templates/stats/top_placement']

    new CPP.Views.Stats.LineGraph
      url: '/students/view_stats_all'
      title: 'Student Profile Views'
      type: 'datetime'
      yAxis: 'Views'
      el: '#student-chart'
      height: 200

    new CPP.Views.Stats.LineGraph
      url: '/companies/view_stats_all'
      title: 'Company Profile Views'
      type: 'datetime'
      yAxis: 'Views'
      el: '#companies-chart'
      height: 200