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

window.tiny_mce_init = ->
  tinyMCE.init
    mode: "textareas"
    theme: "advanced"
    theme_advanced_toolbar_location: "top"
    theme_advanced_toolbar_align: "left"
    theme_advanced_statusbar_location: "none"
    theme_advanced_buttons1: "bold,italic,underline,|,fontselect,fontsizeselect,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,link,unlink,image,code"
    theme_advanced_buttons2: ""
    theme_advanced_buttons3: ""
  console.log "done"

window.tiny_mce_save = ->
  tinyMCE.triggerSave true, true

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


