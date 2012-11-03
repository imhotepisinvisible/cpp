class CPP.Views.EmailsItem extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['emails/item']

  initialize: ->
    #@render()

  events: 
    "click .btn-edit"   : "editEmail"
    "click .btn-delete" : "deleteEmail"
    "click"             : "viewEmail"

  editEmail: (e) ->
    e.stopPropagation()
    Backbone.history.navigate("emails/" + @model.get('id') + "/edit", trigger: true)

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
    Backbone.history.navigate("emails/" + @model.get('id'), trigger: true)