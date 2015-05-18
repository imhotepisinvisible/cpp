CPP.Views.Placements ||= {}

# Placement items (row in placements table)
class CPP.Views.Placements.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/placements/item']

  initialize: ->
    id = @model.get('id')
    @editable = @options.editable

  # Bind events to edit, delete and view
  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-edit"   : "editPlacement"
    "click .btn-delete" : "deletePlacement"
    "click"             : "viewPlacement"

  # Stop propagation to only register event on clicked item
  # Navigate to placement edit page
  editPlacement: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("opportunities/" + @model.get('id') + "/edit", trigger: true)

  # Stop propagation to only register event on clicked item
  # Remove placement on server, remove event propagated to collection which is updated
  deletePlacement: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Opportunity deleted"
      error: (model, response) ->
        notify "error", "Opportunity could not be deleted"

  # Render placement item template
  render: ->
    $(@el).html(@template(placement: @model, editable: @editable ))
    @

  # Navigate to placement view page
  viewPlacement: ->
    Backbone.history.navigate("opportunities/" + @model.get('id'), trigger: true)
