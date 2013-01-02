CPP.Views.Events ||= {}

class CPP.Views.Events.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/events/view']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-signup-student': 'signup'

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(event: @model))
    @

  signup: (event) ->
    if studentAttendEvent(@model)
      $.ajax
        url: "/events/#{@model.id}/unregister",
        dataType: 'json'
        type: "POST"
        data:
          student_id: userId()
        success: (data) =>
          notify("success", "Successfully unregistered")
          @model.registered_students.remove(CPP.CurrentUser)
          $('.btn-signup-student').html('Attend')
        error: (data) ->
          notify("error", "Could not unregister")
    else
      $.ajax
        url: "/events/#{@model.id}/register",
        dataType: 'json'
        type: "POST"
        data:
          student_id: userId()
        success: (data) =>
          notify("success", "Successfully registered as attending")
          @model.registered_students.add(CPP.CurrentUser)
          $('.btn-signup-student').html('Unattend')
        error: (data) ->
          notify("error", "Could not register")
    