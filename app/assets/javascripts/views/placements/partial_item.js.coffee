class CPP.Views.PlacementsPartialItem extends CPP.Views.Base
  tagName: "li"
  className: "placement-item-container"

  events:
    'click .btn-edit' : 'editPlacement'

  template: JST['placements/partial_item']

  initialize: (options) ->
    @editable = options.editable

  render: ->
    $(@el).html(@template(placement: @model, editable: @editable))
    @

  editPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('placements/' + @model.id + '/edit', trigger: true)
