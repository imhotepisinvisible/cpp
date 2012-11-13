class CPP.Views.EventsPartialItem extends CPP.Views.Base
  tagName: "li"
  className: "event-item-container"

  events:
    'click .btn-edit' : 'editEvent'

  template: JST['events/partial_item']

  render: (options) ->
    $(@el).html(@template(event: @model, editable: options.editable))
    @

  editEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('events/' + @model.id + '/edit', trigger: true)
