class CPP.Views.ContactsPartial extends CPP.Views.Base
  template: JST['companies/contacts']
  
  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(contacts: @collection))