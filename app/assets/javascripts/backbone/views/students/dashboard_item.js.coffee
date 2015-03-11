CPP.Views.Students ||= {}

# Events and opportunities partial view for showing on dash pages
class CPP.Views.Students.DashboardItem extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"
  template: JST['backbone/templates/students/dashboard_item']

  initialize: ->
    id = @model.get('id')
    

  # Bind item listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    #"click .button-event-delete" : "deleteEvent"
    #"click .button-event-edit"   : "editEvent"
    "click"                      : "viewItem"


  render: ->
    $(@el).html(@template(event: @model))
    @

  # Navigate to ?????
  viewItem: ->
    Backbone.history.navigate("events/" + @model.get('id'), trigger: true)
