CPP.Views.Placements ||= {}

class CPP.Views.Placements.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/placements/item']

  initialize: ->
    #@render()

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-edit"   : "editPlacement"
    "click .btn-delete" : "deletePlacement"
    "click"             : "viewPlacement"

  editPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("placements/" + @model.get('id') + "/edit", trigger: true)

  deletePlacement: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Placement deleted"
        $(e.target).parent().parent().parent().remove()
      error: (model, response) ->
        notify "error", "Placement could not be deleted"

  render: ->
    $(@el).html(@template(placement: @model))
    @

  viewPlacement: ->
    Backbone.history.navigate("placements/" + @model.get('id'), trigger: true)
