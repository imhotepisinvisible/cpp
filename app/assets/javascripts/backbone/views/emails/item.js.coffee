CPP.Views.Emails ||= {}

class CPP.Views.Emails.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/emails/item']

  initialize: ->
    #@render()

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-edit"   : "editEmail"
    "click .btn-delete" : "deleteEmail"
    "click"             : "viewEmail"

  editEmail: (e) ->
    e.stopPropagation()
    switch @options.type
      when "tagged" then Backbone.history.navigate("tagged_emails/" + @model.get('id') + "/edit", trigger: true)
      when "direct" then Backbone.history.navigate("direct_emails/" + @model.get('id') + "/edit", trigger: true)
      when "event"  then Backbone.history.navigate("event_emails/" + @model.get('id') + "/edit", trigger: true)

  deleteEmail: (e) ->
    e.stopPropagation()
    @model.destroy
      wait: true
      success: (model, response) ->
        notify "success", "Email deleted"
      error: (model, response) ->
        notify "error", "Email could not be deleted"

  render: ->
    $(@el).html(@template(email: @model))
    @

  viewEmail: ->
    switch @type
      when "tagged" then Backbone.history.navigate("tagged_emails/" + @model.get('id'), trigger: true)
      when "direct" then Backbone.history.navigate("direct_emails/" + @model.get('id'), trigger: true)
      when "event"  then Backbone.history.navigate("event_emails/" + @model.get('id'), trigger: true)
