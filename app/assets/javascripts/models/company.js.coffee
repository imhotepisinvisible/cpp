class CPP.Models.Company extends Backbone.Model
  initialize: ->
    @hidden = false;

    @events = new CPP.Collections.Events
    @events.url = '/companies/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/companies/' + this.id + '/placements'

    @emails = new CPP.Collections.Emails
    @emails.url = '/companies/' + this.id + '/emails'

    @company_contacts = new CPP.Collections.CompanyContacts
    @company_contacts.url = '/companies/' + this.id + '/company_contacts'
    
  url: ->
    '/companies' + (if @isNew() then '' else '/' + @id)
