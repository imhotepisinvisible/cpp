class CPP.Views.PlacementsPartialItem extends CPP.Views.Base
  tagName: "li"
  className: "placement-item-container"

  editable: false

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit'       : 'editPlacement'
    'click .placement-item' : 'viewPlacement'

  template: JST['backbone/templates/placements/partial_item']

  initialize: (options) ->
    @editable = options.editable

  render: ->
    $(@el).html(@template(placement: @model, editable: @editable))
    @

  editPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('placements/' + @model.id + '/edit', trigger: true)

  viewPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('placements/' + @model.id, trigger: true)
