window.CPP =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new CPP.Routers.Companies
    new CPP.Routers.Events
    Backbone.history.start({pushState: true})

window.notify = (alert_class, message) ->
  n = $("#notifications")
  n.hide()
  n.removeClass()
  n.addClass("alert alert-" + alert_class)
  n.html(message)
  n.slideDown().delay(2000).slideUp()

$(document).ready ->
  Backbone.Form.editors.DateTime.DateEditor = Backbone.Form.editors.Datepicker
  # Bind DatePickers
# $(document).on "focus", "[data-behaviour~='datepicker']", (e) ->
#    $(this).datepicker
#      "format":     "dd/mm/yyyy"
#      "weekStart":  1
#      "autoclose":  true

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
