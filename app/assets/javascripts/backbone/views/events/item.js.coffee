CPP.Views.Events ||= {}

class CPP.Views.Events.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/events/item']

  initialize: ->
    id = @model.get('id')
    @editable = @options.editable

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .button-event-delete" : "deleteEvent"
    "click .button-event-edit"   : "editEvent"
    "click"                      : "viewEvent"

  editEvent: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("events/" + @model.get('id') + "/edit", trigger: true)

  deleteEvent: (e) ->
    # Remove item from view
    $(e.target).parent().parent().remove();
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Event deleted"
      error: (model, response) ->
        notify "error", "Event could not be deleted"

  render: ->
    $(@el).html(@template(event: @model, editable: @editable))
    @

  viewEvent: ->
    Backbone.history.navigate("events/" + @model.get('id'), trigger: true)
