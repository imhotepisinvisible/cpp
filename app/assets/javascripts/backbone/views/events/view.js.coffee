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
    button = $('.btn-signup-student')
    if studentAttendEvent(@model)
      console.log "Attending"
    else
      console.log "Unattending"