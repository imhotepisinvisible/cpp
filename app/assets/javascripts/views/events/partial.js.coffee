class CPP.Views.EventsPartial extends Backbone.View
  template: JST['events/partial']

  initialize: ->
    @collection.bind 'reset', @render, @
    @render()

  render: ->
    $(@el).html(@template())

    @collection.each (event) =>
      view = new CPP.Views.EventsPartialItem model: event
      @$('#events').append(view.render().el)
    @
