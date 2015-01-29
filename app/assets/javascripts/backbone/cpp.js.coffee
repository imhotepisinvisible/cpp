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
    window.CPPRouter = new CPP.Router
    new CPP.Routers.Companies
    new CPP.Routers.Students
    new CPP.Routers.Events
    new CPP.Routers.Placements
    new CPP.Routers.Emails
    new CPP.Routers.TaggedEmails
    new CPP.Routers.EventEmails
    new CPP.Routers.DirectEmails
    new CPP.Routers.CompanyContacts
    new CPP.Routers.ForgotPassword
    new CPP.Routers.Departments
    new CPP.Routers.Courses
    #new CPP.Routers.Site
    Backbone.history.start({pushState: true})
    #Backbone.history.start()


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
        401: (data) ->
          console.log "Got 401"
          if loggedIn()
            notify("error", data.responseText, 4000)
          else
            notify("error", "You need to log in to do that!", 4000)
        403: (data) ->
          console.log "Got 403"
        404: (data) ->
          console.log "Got 404"

  # Start the app <-- VERY important ;)
  CPP.init()

# Globally capture clicks. If they are internal and not in the pass
# through list, route them through Backbone's navigate method.
$(document).on "click", "a[href^='/']", (event) ->

  href = $(event.currentTarget).attr('href')

  # chain 'or's for other black list routes
  passThrough = href.indexOf('logout') >= 0 || href.indexOf('courses') >= 0 || href.indexOf('documents') >= 0 || href.indexOf('.csv') >= 0

  # Allow shift+click for new tabs, etc.
  if !passThrough && !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
    event.preventDefault()

    # Remove leading slashes and hash bangs (backward compatibility)
    url = href.replace(/^\//,'').replace('\#\!\/','')

    # Instruct Backbone to trigger routing events
    CPPRouter.navigate url, { trigger: true }

    return false
