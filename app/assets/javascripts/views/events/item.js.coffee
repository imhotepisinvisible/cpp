class CPP.Views.EventsItem extends CPP.Views.Base
  tagName: "tr"

  template: JST['events/item']

  events: 
    "click .btn-edit" : "editEvent"
    "click .btn-delete" : "deleteEvent"

  editEvent: ->
    console.log("edit event " + @model.get("title")) 

  deleteEvent: ->
    console.log("delete event " + @model.get("title")) 

  render: ->
    $(@el).html(@template(event: @model))
    @
