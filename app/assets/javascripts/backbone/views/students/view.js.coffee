class CPP.Views.StudentsView extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/view']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(student: @model))
    super
    @
