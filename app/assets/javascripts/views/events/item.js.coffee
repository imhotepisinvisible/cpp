class CPP.Views.EventsItem extends CPP.Views.Base
  tagName: "tr"

  template: JST['events/item']

  initialize: ->
    #@render()

  events: 
    "click .btn-edit" : "editEvent"
    "click .btn-delete" : "deleteEvent"
    "click .btn-view" : "viewEvent"

  editEvent: ->
    Backbone.history.navigate("events/" + @model.get('id') + "/edit", trigger: true)

  deleteEvent: ->
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Event deleted"
      error: (model, response) ->
        notify "error", "Event could not be deleted"

  viewEvent: ->
    Backbone.history.navigate("events/" + @model.get('id'), trigger: true)

  render: ->
    $(@el).html(@template(event: @model))
    @
