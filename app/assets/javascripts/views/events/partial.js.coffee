class CPP.Views.EventsPartial extends CPP.Views.Base
  template: JST['events/partial']

  events:
    "click .btn-add"      : "addEvent"
    "click .btn-view-all" : "viewCompaniesEvents"

  initialize: (options) ->
    @editable = options.editable
    @collection.bind 'reset', @render, @
    @render(editable: @editable)

  render: (options) ->
    $(@el).html(@template(editable: @editable))
    @collection.each (event) =>
      view = new CPP.Views.EventsPartialItem model: event
      @$('#events').append(view.render(editable: @editable).el)
    @

  addEvent: ->
    Backbone.history.navigate("companies/" + @model.id + "/events/new", trigger: true)

  viewCompaniesEvents: ->
    Backbone.history.navigate("companies/" + @model.id + "/events", trigger: true)
