class CPP.Views.PlacementsPartial extends Backbone.View
  template: JST['placements/partial']

  initialize: ->
    @collection.bind 'reset', @render, @
    @render()

  render: ->
    $(@el).html(@template())

    @collection.each (placement) =>
      view = new CPP.Views.PlacementsPartialItem model: placement
      @$('#placements').append(view.render().el)
    @