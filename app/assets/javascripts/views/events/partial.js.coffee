class CPP.Views.EventsPartial extends CPP.Views.Base
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
