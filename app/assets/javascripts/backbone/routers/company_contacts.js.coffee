class CPP.Routers.CompanyContacts extends Backbone.Router
  routes:
    'companies/:id/company_contacts/edit' : 'edit'
    'companies/:id/company_contacts'      : 'view'

  # Edit company contacts
  edit: (id) ->
    if isStudent()
      window.history.back()
      return false
    contacts = new CPP.Collections.CompanyContacts
    contacts.fetch
      data:
        $.param({ company_id: id})
      success: ->
        # Reuse partial for full page
        new CPP.Views.Contacts.PartialEdit
          collection: contacts
          company_id: id
          el: '#app'
      error: ->
        notify "error", "Couldn't fetch contacts"

  # View company contacts
  view: (id) ->
    contacts = new CPP.Collections.CompanyContacts
    contacts.fetch
      data:
        $.param({ company_id: id})
      success: ->
        # Reuse partial
        new CPP.Views.Contacts.Partial
          collection: contacts
          company_id: id
          el: '#app'
      error: ->
        notify "error", "Couldn't fetch contacts"
