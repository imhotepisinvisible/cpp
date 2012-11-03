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

    new CPP.Views.LoginUser
    # Backbone.history.start({pushState: true})
    Backbone.history.start()

window.notify = (alert_class, message) ->
  n = $("#notifications")
  n.hide()
  n.removeClass()
  n.addClass("alert alert-" + alert_class)
  n.html(message)
  n.slideDown().delay(2000).slideUp()


$(document).ready ->
  Backbone.Form.editors.DateTime.DateEditor = Backbone.Form.editors.Datepicker

  $.ajaxSetup
    statusCode:
        401: ->
          console.log "Got 401"
          notify("error", "Twas an error!")
        403: ->
          console.log "Got 403"
        404: ->
          console.log "Got 404"
  CPP.init()
