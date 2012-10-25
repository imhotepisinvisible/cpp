class CPP.Views.EventsPartialItem extends CPP.Views.Base
  tagName: "li"

  events:
    'click .btn-edit' : 'editEvent'

  template: JST['events/partial_item']

  render: ->
    $(@el).html(@template(event: @model))
    @

  editEvent: ->
    Backbone.history.navigate('events/' + @model.id + '/edit', trigger: true)
