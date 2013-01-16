CPP.Views.Events ||= {}

# Event Partial Item, used to display minature of event on a dashboard
class CPP.Views.Events.PartialItem extends CPP.Views.Base
  tagName: "li"
  className: "event-item-container"

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit' : 'editEvent'
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

  # View the event  
  viewEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('events/' + @model.id, trigger: true)

