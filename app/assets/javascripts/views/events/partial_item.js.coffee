class CPP.Views.EventsPartialItem extends CPP.Views.Base
  tagName: "li"

  events:
    'click .btn-edit' : 'editEvent'
    'click .link-description' : 'viewEvent'

  template: JST['events/partial_item']

  render: (options) ->
    $(@el).html(@template(event: @model, editable: options.editable))
    @

  editEvent: ->
    Backbone.history.navigate('events/' + @model.id + '/edit', trigger: true)

  viewEvent: ->
    Backbone.history.navigate('events/' + @model.id, trigger: true)