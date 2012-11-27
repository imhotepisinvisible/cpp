_.extend Backbone.Model::, Backbone.Validation.mixin

window.CPP =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new CPP.Routers.Companies
    new CPP.Routers.Students
    new CPP.Routers.Events
    new CPP.Routers.Placements
    new CPP.Routers.Emails
    new CPP.Routers.CompanyContacts
    # new CPP.Views.NavLogin {model: new CPP.Models.LoginStatus()}
    # Backbone.history.start({pushState: true})
    Backbone.history.start()


$(document).ready ->
  Backbone.Form.editors.DateTime.DateEditor = Backbone.Form.editors.Datepicker

  # Add standard template (does not have class form-horizontal with huge margins)
  Backbone.Form.setTemplates(
    standardForm: '<form>{{fieldsets}}</form>'
  )

  $.ajaxSetup
    statusCode:
        401: ->
          console.log "Got 401"
        403: (data) ->
          console.log "Got 403"
          notify("error", data.responseText, 4000)
        404: ->
          console.log "Got 404"
  CPP.init()


