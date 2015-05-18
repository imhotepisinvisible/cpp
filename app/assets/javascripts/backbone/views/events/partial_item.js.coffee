CPP.Views.Events ||= {}

# Event Partial Item, used to display minature of event on a dashboard
class CPP.Views.Events.PartialItem extends CPP.Views.Base
  tagName: "li"
  className: "event-item-container"

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit'   : 'editEvent'
    'click .btn-delete' : 'deleteEvent'
    'click .event-item' : 'viewEvent'

  template: JST['backbone/templates/events/partial_item']

  # Initialise and set editable
  initialize: (options) ->
    @editable = options.editable

  # Render event partial item template
  render: ->
    $(@el).html(@template(model: @model, editable: @editable))
    @

  # Edit the event
  editEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("events/" + @model.id + "/edit", trigger: true)

  # View the event
  viewEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('events/' + @model.id, trigger: true)

  deleteEvent: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Event deleted"
      error: (model, response) ->
        notify "error", "Event could not be deleted"
