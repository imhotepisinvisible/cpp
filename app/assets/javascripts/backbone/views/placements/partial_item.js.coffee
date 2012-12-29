CPP.Views.Placements ||= {}

class CPP.Views.Placements.PartialItem extends CPP.Views.Base
  tagName: "li"
  className: "placement-item-container"

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit'       : 'editPlacement'
    'click .placement-item' : 'viewPlacement'

  template: JST['backbone/templates/placements/partial_item']

  initialize: (options) ->
    @editable = options.editable

  render: ->
    $(@el).html(@template(model: @model, editable: @editable))
    @

  editPlacement: (e) ->
    e.stopPropagation()

  viewPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('placements/' + @model.id, trigger: true)
