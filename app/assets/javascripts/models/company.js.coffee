class CPP.Models.Company extends Backbone.Model
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/companies/' + this.id + '/events'
    @events.fetch()

    @placements = new CPP.Collections.Placements
    @placements.url = '/companies/' + this.id + '/placements'
    @placements.fetch()

  url: ->
    '/companies' + (if @isNew() then '' else '/' + @id)