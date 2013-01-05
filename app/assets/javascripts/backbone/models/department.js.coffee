class CPP.Models.Department extends CPP.Models.Base
  initialize: ->
    @pending_companies = new CPP.Collections.Companies
    @pending_companies.url = '/departments/' + this.id + '/companies/pending'
    @pending_emails = new CPP.Collections.Emails
    @pending_emails.url = '/emails/pending'

  url: ->
    '/departments' + (if @isNew() then '' else '/' + @id)

  toString: ->
    return this.get 'name'

class CPP.Collections.Departments extends CPP.Collections.Base
  url: '/departments'
  model: CPP.Models.Department
