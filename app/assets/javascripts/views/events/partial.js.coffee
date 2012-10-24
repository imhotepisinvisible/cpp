class CPP.Views.EventsPartial extends CPP.Views.Base
  template: JST['events/partial']

  events:
    "click .btn-add" : "addCompany"

  initialize: ->
    @collection.bind 'reset', @render, @
    @render()

  render: ->
    $(@el).html(@template())

    @collection.each (event) =>
      view = new CPP.Views.EventsPartialItem model: event
      @$('#events').append(view.render().el)
    @

  addCompany: ->
    Backbone.history.navigate("events/new", trigger: true)
