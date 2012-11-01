class CPP.Views.PlacementsPartialItem extends CPP.Views.Base
  tagName: "li"
  className: "placement-item"

  events:
    'click .btn-edit' : 'editPlacement'
    'click'           : 'viewPlacement'

  template: JST['placements/partial_item']

  render: (options) ->
    $(@el).html(@template(placement: @model, editable: options.editable))
    @

  editPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('placements/' + @model.id + '/edit', trigger: true)

  viewPlacement: ->
    Backbone.history.navigate('placements/' + @model.id, trigger: true)
