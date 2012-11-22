class CPP.Views.ContactsPartial extends CPP.Views.Base
  template: JST['companies/contacts']
  
  initialize: ->
    @render()

  render: ->
    # Should be @model.get 'contacts'
    $(@el).html(@template(contacts: @model))