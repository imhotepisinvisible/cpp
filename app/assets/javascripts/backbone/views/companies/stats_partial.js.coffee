CPP.Views.Companies ||= {}

class CPP.Views.Companies.StatsPartial extends CPP.Views.Base
  template: JST['backbone/templates/companies/stat_partial']

  initialize: (options) ->
    # Get Data
    $.get "/companies/1/view_stats", (data) =>
      @series_data = data
      @render()

  render: () ->
    new Highcharts.Chart
      chart:
        renderTo: 'orders_chart'
        height: 300
      title:
        text: 'Student Views'
      xAxis:
        type: 'datetime'
      yAxis:
        title:
          text: 'Views'
        min: 0
      series: [
        @series_data
      ]
