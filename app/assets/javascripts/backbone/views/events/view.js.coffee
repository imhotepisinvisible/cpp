CPP.Views.Events ||= {}

class CPP.Views.Events.View extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/events/view']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-signup-student': 'signup'

  # If student record that the event has been viewed by a student
  # for companies to use later
  initialize: ->
    if isStudent()
      @model.record_stat_view()
    @render()

  # Display event view
  render: ->
    $(@el).html(@template(
      event: @model,
      student: isStudent(),
      admin: isAdmin(),
      attending: studentAttendEvent(@model),
    ))
    @

  # Sign student up by registering student on server
  signup: (event) ->
    if @model.getFilled() == @model.get('capacity')
      notify("error", "Cannot sign up, event is full")
    else if studentAttendEvent(@model)
      $.ajax
        url: "/events/#{@model.id}/unregister",
        dataType: 'json'
        type: "POST"
        data:
          student_id: userId()
        success: (data) =>
          notify("success", "Successfully unregistered")
          @model.registered_students.remove(CPP.CurrentUser)
          @updateViewCapacity false
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
          @updateViewCapacity true
        error: (data) ->
          notify("error", "Could not register")

  # Update capacity bar and student attending button based on 
  # attending parameter.
  updateViewCapacity: (attending) ->
    $('#capacity-text').html("#{@model.getFilled()} / #{@model.get 'capacity'}")
    $('#capacity-progress').removeClass 'progress-info progress-danger progress-warning'
    $('#capacity-progress').addClass "progress-#{@model.getCapacityClass()}"
    $('#capacity-bar').width("#{@model.getPercentageCapacity()}%")
    $('#btn-signup-student').html(if attending then "Relinquish my ticket" else "Sign me up!")
    $('#attending-text').html((unless attending then 'Not ' else '') + 'Attending!!')
    $('#number-attending').html(@model.getFilled())
