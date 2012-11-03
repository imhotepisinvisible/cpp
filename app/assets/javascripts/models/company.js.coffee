class CPP.Models.Company extends Backbone.Model
  initialize: ->
    @events = new CPP.Collections.Events
    @events.url = '/companies/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/companies/' + this.id + '/placements'

    @emails = new CPP.Collections.Emails
    @emails.url = '/companies/' + this.id + '/emails'

  url: ->
    '/companies' + (if @isNew() then '' else '/' + @id)