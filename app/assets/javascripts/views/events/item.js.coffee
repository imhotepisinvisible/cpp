class CPP.Views.EventsItem extends CPP.Views.Base
  tagName: "tr"

  template: JST['events/item']

  events: 
    "click .btn-edit" : "editEvent"
    "click .btn-delete" : "deleteEvent"

  editEvent: ->
    Backbone.history.navigate("events/" + @model.get('id') + "/edit", trigger: true)

  deleteEvent: ->
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Event deleted"
      error: (model, response) ->
        notify "error", "Event could not be deleted"

  render: ->
    $(@el).html(@template(event: @model))
    @
