class CPP.Views.EventsPartialItem extends CPP.Views.Base
  tagName: "li"
  className: "event-item-container"

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit' : 'editEvent'
    'click .event-item' : 'viewEvent'

  template: JST['events/partial_item']

  initialize: (options) ->
    @editable = options.editable

  render: ->
    $(@el).html(@template(event: @model, editable: @editable))
    @

  editEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('events/' + @model.id + '/edit', trigger: true)

  viewEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('events/' + @model.id, trigger: true)

