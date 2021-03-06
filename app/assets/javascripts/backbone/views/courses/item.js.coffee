
class CPP.Views.Courses.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/courses/item']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .button-course-delete'     : 'delete'
    'click .button-course-edit'       : 'edit'

  render: ->
    $(@el).html(@template(course: @model))
    @

  # Delete the course
  delete: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Course deleted"
      error: (model, response) ->
        notify "error", "Course could not be deleted"


  edit: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("courses/" +@model.id + "/edit", trigger: true)
    
  
