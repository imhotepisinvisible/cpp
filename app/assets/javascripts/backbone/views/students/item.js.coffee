CPP.Views.Students ||= {}
# Student items (row in student table)
class CPP.Views.Students.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/students/item']

  # Set editable on initialisation
  initialize: ->
    @editable = @options.editable

  # Bind eventsto edit, delete and view
  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-student-delete" : "deleteStudent"
    "click .button-student-edit"   : "editStudent"
    "click .button-student-cv"     : "downloadCVStudent"
    "click"                        : "viewStudent"


  # Stop propagation to only register event on clicked item
  # Navigate to students cv to download 
  downloadCVStudent: (e) ->
    e.stopPropagation()
    window.location = "students/" + @model.get('id') + "/documents/cv"

  # Stop propagation to only register event on clicked item
  # Navigate to students edit page
  editStudent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("students/" + @model.get('id') + "/edit", trigger: true)

  # Stop propagation to only register event on clicked item
  # Delete student, remove event propagated to collection which is then updated
  deleteStudent: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Student deleted"
      error: (model, response) ->
        notify "error", "Student could not be deleted"

  # Render student item template
  render: ->
    $(@el).html(@template(student: @model, editable: @editable))
    @

  # Navigate to student view page
  viewStudent: ->
    Backbone.history.navigate("students/" + @model.get('id'), trigger: true)
