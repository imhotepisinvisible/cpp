class CPP.Models.Company extends Backbone.Model
  initialize: ->
    @hidden = false;

    @events = new CPP.Collections.Events
    @events.url = '/companies/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/companies/' + this.id + '/placements'

    @tagged_emails = new CPP.Collections.TaggedEmails
    @tagged_emails.url = '/companies/' + this.id + '/tagged_emails'

    @company_contacts = new CPP.Collections.CompanyContacts
    @company_contacts.url = '/companies/' + this.id + '/company_contacts'
    
    @departments = new CPP.Collections.Departments
    @departments.url = '/companies/' + this.id + '/departments'

  url: ->
    '/companies' + (if @isNew() then '' else '/' + @id)

  getStarClass: ->
    if @get('rating') == 1
      return "golden-star icon-star"
    return "icon-star-empty"

  getBanClass: ->
    if @get('rating') == 3
      return "red-ban icon-ban-circle"
    return "icon-ban-circle"    