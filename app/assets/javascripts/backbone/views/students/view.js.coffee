CPP.Views.Students ||= {}

# Student view
class CPP.Views.Students.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/view']

  # If user is admin then record view of student
  initialize: ->
    if isCompanyAdmin()
      @model.record_stat_view()
    @model.bind 'change', @render, @
    @render()

  # render student template with student model
  render: ->
    if @model.get("first_name")
      $(@el).html(@template(student: @model, courses: @courses))
    super
    @
