CPP.Views.Students ||= {}

class CPP.Views.Students.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/students/item']

  initialize: ->
    @editable = @options.editable

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-student-delete" : "deleteStudent"
    "click .button-student-edit"   : "editStudent"
    "click .button-student-cv"     : "downloadCVStudent"
    "click"                        : "viewStudent"


  downloadCVStudent: (e) ->
    e.stopPropagation()
    window.location = "students/" + @model.get('id') + "/documents/cv"

  editStudent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("students/" + @model.get('id') + "/edit", trigger: true)

  deleteStudent: (e) ->
    # Remove item from view
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Student deleted"
      error: (model, response) ->
        notify "error", "Student could not be deleted"

  render: ->
    $(@el).html(@template(student: @model, editable: @editable))
    @

  viewStudent: ->
    Backbone.history.navigate("students/" + @model.get('id'), trigger: true)
