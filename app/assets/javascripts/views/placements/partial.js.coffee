class CPP.Views.PlacementsPartial extends CPP.Views.Base
  template: JST['placements/partial']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-add"      : "addPlacement"
    "click .btn-view-all" : "viewCompaniesPlacements"

  initialize: (options) ->
    @editable = options.editable || false
    @collection.bind 'reset', @render, @
    @render()

  render: () ->
    $(@el).html(@template(editable: @editable))

    if @collection.length > 0
      @collection.each (placement) =>
        view = new CPP.Views.PlacementsPartialItem
                    model: placement
                    editable: @editable
        @$('#placements').append(view.render().el)
    else
      @$('#placements').append "No events right now!"
    @

  addPlacement: ->
    Backbone.history.navigate("companies/" + @model.id + "/placements/new", trigger: true)

  viewCompaniesPlacements: ->
    Backbone.history.navigate("companies/" + @model.id + "/placements", trigger: true)

