class CPP.Views.EventsPartialItem extends CPP.Views.Base
  tagName: "li"

  template: JST['events/partial_item']

  render: ->
    $(@el).html(@template(event: @model))
    @
