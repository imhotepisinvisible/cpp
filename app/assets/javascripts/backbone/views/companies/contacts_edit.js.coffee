class CPP.Views.ContactsPartialEdit extends CPP.Views.Base
  template: JST['backbone/templates/companies/contacts_edit']

  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(contacts: @model.get 'company_contacts'))
