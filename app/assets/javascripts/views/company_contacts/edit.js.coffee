class CPP.Views.ContactsPartialEdit extends CPP.Views.Base
  template: JST['company_contacts/contacts_edit']
  
  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(contacts: @collection))