class CPP.Models.Department extends CPP.Models.Base
  initialize: ->
    @pending_companies = new CPP.Collections.Companies
    @pending_companies.url = '/departments/' + this.id + '/companies/pending'
    @pending_emails = new CPP.Collections.Emails
    @pending_emails.url = '/emails/pending'
    @pending_events = new CPP.Collections.Events
    @pending_events.url = '/events/pending'
    @pending_placements = new CPP.Collections.Placements
    @pending_placements.url = '/placements/pending'

  url: ->
    '/departments' + (if @isNew() then '' else '/' + @id)

  toString: ->
    return @get('name')

class CPP.Collections.Departments extends CPP.Collections.Base
  url: '/departments'
  model: CPP.Models.Department
