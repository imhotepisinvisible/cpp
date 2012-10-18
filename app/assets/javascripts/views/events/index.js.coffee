class CPP.Views.EventsIndex extends Backbone.View
  el: '#app'
  template: JST['events/index']

  initialize: ->
    @collection.bind 'reset', @render, @

  render: ->
    $(@el).html(@template())

    @collection.each (event) =>
      view = new CPP.Views.EventsItem model: event
      @$('#events').append(view.render().el)
    @
