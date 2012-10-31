class CPP.Views.EventsItem extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['events/item']

  initialize: ->
    #@render()

  events: 
    "click .btn-edit"   : "editEvent"
    "click .btn-delete" : "deleteEvent"
    "click"             : "viewEvent"

  editEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("events/" + @model.get('id') + "/edit", trigger: true)

  deleteEvent: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Event deleted"
      error: (model, response) ->
        notify "error", "Event could not be deleted"

  render: ->
    $(@el).html(@template(event: @model))
    @

  viewEvent: ->
    Backbone.history.navigate("events/" + @model.get('id'), trigger: true)