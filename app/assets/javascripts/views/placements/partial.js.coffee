class CPP.Views.PlacementsPartial extends CPP.Views.Base
  template: JST['placements/partial']

  events:
    "click .btn-add"      : "addPlacement"
    "click .btn-view-all" : "viewCompaniesPlacements"

  initialize: (options) ->
    @editable = options.editable
    @collection.bind 'reset', @render, @
    @render(editable: @editable)

  render: () ->
    $(@el).html(@template(editable: @editable))
    @collection.each (placement) =>
      view = new CPP.Views.PlacementsPartialItem model: placement
      @$('#placements').append(view.render(editable: @editable).el)
    @

  addPlacement: ->
    Backbone.history.navigate("companies/" + @model.id + "/placements/new", trigger: true)

  viewCompaniesPlacements: ->
    Backbone.history.navigate("companies/" + @model.id + "/placements", trigger: true)

