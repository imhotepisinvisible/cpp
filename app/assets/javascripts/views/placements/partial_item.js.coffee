class CPP.Views.PlacementsPartialItem extends CPP.Views.Base
  tagName: "li"

  template: JST['placements/partial_item']

  render: ->
    $(@el).html(@template(placement: @model))
    @
