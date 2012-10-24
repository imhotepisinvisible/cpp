class CPP.Views.EventsPartialItem extends Backbone.View
  tagName: "li"

  template: JST['events/partial_item']

  render: ->
    $(@el).html(@template(event: @model))
    @
