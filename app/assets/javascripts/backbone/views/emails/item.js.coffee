CPP.Views.Emails ||= {}

# Individual item for email
class CPP.Views.Emails.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/emails/item']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-edit"   : "editEmail"
    "click .btn-delete" : "deleteEmail"
    "click"             : "viewEmail"

  # Navigate to correct edit based upon email type
  editEmail: (e) ->
    e.stopPropagation()
    switch @options.type
      when "tagged" then Backbone.history.navigate("tagged_emails/" + @model.get('id') + "/edit", trigger: true)
      when "direct" then Backbone.history.navigate("direct_emails/" + @model.get('id') + "/edit", trigger: true)
      when "event"  then Backbone.history.navigate("event_emails/" + @model.get('id') + "/edit", trigger: true)
      else Backbone.history.navigate("emails/" + @model.get('id') + "/edit", trigger: true)

  # Delete email and update server
  deleteEmail: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Email deleted"
      error: (model, response) ->
        notify "error", "Email could not be deleted"

  # Render item template
  render: ->
    $(@el).html(@template(email: @model))
    @

  # View email based upon email type
  viewEmail: ->
    switch @options.type
      when "tagged" then Backbone.history.navigate("tagged_emails/" + @model.get('id'), trigger: true)
      when "direct" then Backbone.history.navigate("direct_emails/" + @model.get('id'), trigger: true)
      when "event"  then Backbone.history.navigate("event_emails/" + @model.get('id'), trigger: true)
      else Backbone.history.navigate("emails/" + @model.get('id'), trigger: true)
