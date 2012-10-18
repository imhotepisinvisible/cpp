window.CPP =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    # new CPP.Routers.Companies
    Backbone.history.start()

$(document).ready ->
  CPP.init()
