class CPP.Models.Company extends Backbone.Model
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/companies/' + this.id + '/events'
    @events.fetch()
    @events.on("reset", @eventsUpdated)

  eventsUpdated: ->
    console.log "EVENTS UPDATED"
