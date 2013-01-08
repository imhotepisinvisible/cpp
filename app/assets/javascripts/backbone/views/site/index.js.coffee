CPP.Views.Site ||= {}

class CPP.Views.Site.Index extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/site/index']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(student: @model))
    super
    @
