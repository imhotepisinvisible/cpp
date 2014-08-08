CPP.Views.Students ||= {}

# Student view
class CPP.Views.Students.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/view']

  # If user is admin then record view of student
  initialize: ->
    if isCompanyAdmin()
      @model.record_stat_view()
    @render()

  # render student template with student model
  render: ->
    @model.courses.fetch({async:false })
    $(@el).html(@template(student: @model))
    super
    @
