class CPP.Routers.CompanyContacts extends Backbone.Router
  routes:
      'company_contacts/:id/edit'                   : 'edit'
      'companies/:company_id/company_contacts'      : 'view'

  edit: (id) ->
    contact = new CPP.Models.CompanyContact id: id
    contact.fetch
      success: ->
        new CPP.Views.ContactsPartialEdit model: contact
      error: ->
        notify "error", "Couldn't fetch contact"

  view: (company_id) ->
    contacts = new CPP.Collections.CompanyContacts
    contacts.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        new CPP.Views.ContactsPartial collection: contacts
      error: ->
        notify "error", "Couldn't fetch contact"
