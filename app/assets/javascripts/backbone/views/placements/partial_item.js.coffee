CPP.Views.Placements ||= {}

# Placement partial item within the top three placement partial
class CPP.Views.Placements.PartialItem extends CPP.Views.Base
  tagName: "li"
  className: "placement-item-container"

  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit'       : 'editPlacement'
    'click .btn-delete'     : 'deletePlacement'
    'click .placement-item' : 'viewPlacement'

  template: JST['backbone/templates/placements/partial_item']

  # Initialise with editable set
  initialize: (options) ->
    @editable = options.editable

  # render placement partial item template
  render: ->
    $(@el).html(@template(model: @model, editable: @editable))
    @

  # Stop propagation to only register event on clicked item
  # Edit placement via placement edit button
  editPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("opportunities/" + @model.id + "/edit", trigger: true)

  # Stop propagation to only register event on clicked item
  # View placement via clicking on partial item
  viewPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('opportunities/' + @model.id, trigger: true)

  deletePlacement: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Opportunity deleted"
      error: (model, response) ->
        notify "error", "Opportunity could not be deleted"
