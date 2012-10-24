class CPP.Views.PlacementsPartialItem extends Backbone.View
  tagName: "li"

  template: JST['placements/partial_item']

  render: ->
    $(@el).html(@template(placement: @model))
    @