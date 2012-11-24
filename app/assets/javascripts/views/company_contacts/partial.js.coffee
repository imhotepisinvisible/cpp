class CPP.Views.ContactsPartial extends CPP.Views.Base
  template: JST['company_contacts/contacts']
  
  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(contacts: @collection))