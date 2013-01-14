CPP.Views.Stats ||= {}

# Stats graph
class CPP.Views.Stats.LineGraph extends CPP.Views.Base
  # Set graph properties and data then render
  initialize: ->
    @title = @options.title
    @type = @options.type
    @yAxis = @options.yAxis
    @height = if @options.height then @options.height else 300
    $.get @options.url, (data) =>
      @series_data = data
      @render()

  # Render chart using set properties and data
  render: () ->
    new Highcharts.Chart
      chart:
        renderTo: @el
        height: 300
      title:
        text: @title
      xAxis:
        type: @type
      yAxis:
        title:
          text: @yAxis
        minTickInterval: 1
        min: 0
      series: [
        @series_data
      ]
