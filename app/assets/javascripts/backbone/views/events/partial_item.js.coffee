CPP.Views.Events ||= {}

class CPP.Views.Events.PartialItem extends CPP.Views.Base
  tagName: "li"
  className: "event-item-container"

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit' : 'editEvent'
    'click .event-item' : 'viewEvent'

  template: JST['backbone/templates/events/partial_item']

  initialize: (options) ->
    @editable = options.editable

  render: ->
    $(@el).html(@template(model: @model, editable: @editable))
    @

  editEvent: (e) ->
    e.stopPropagation()

  viewEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('events/' + @model.id, trigger: true)
