CPP.Views.Students ||= {}

class CPP.Views.Students.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/view']

  initialize: ->
    if isCompanyAdmin()
      @model.record_stat_view()
    @render()

  render: ->
    $(@el).html(@template(student: @model))
    super
    @
