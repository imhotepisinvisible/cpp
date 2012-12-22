#= require_self
#= require_tree ./custom_forms
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

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
    new CPP.Routers.TaggedEmails
    new CPP.Routers.CompanyContacts
    # Backbone.history.start({pushState: true})
    Backbone.history.start()


$(document).ready ->

  # Add validation to models
  _.extend Backbone.Model::, Backbone.Validation.mixin

  # Datetime form for nicer datapickers
  Backbone.Form.editors.DateTime.DateEditor = Backbone.Form.editors.Datepicker

  # Add standard template (does not have class form-horizontal with huge margins)
  Backbone.Form.setTemplates(
    standardForm: '<form>{{fieldsets}}</form>'
  )

  # Catch standard ajax errors
  # 401 - Auth error, someone tried to access something they shouldn't!
  # 403 - Forbidden, will never be allowed!
  # 404 - Whatever you want, we don't have it
  $.ajaxSetup
    statusCode:
        401: ->
          console.log "Got 401"
          notify("error", data.responseText, 4000)
        403: (data) ->
          console.log "Got 403"
        404: ->
          console.log "Got 404"

  # Start the app <-- VERY important ;)
  CPP.init()


