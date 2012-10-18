window.CPP =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new CPP.Routers.Companies
    new CPP.Routers.Events
    Backbone.history.start()

$(document).ready ->
  CPP.init()
