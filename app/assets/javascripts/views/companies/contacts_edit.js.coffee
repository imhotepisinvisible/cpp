class CPP.Views.ContactsPartialEdit extends CPP.Views.Base
  template: JST['companies/contacts_edit']
  
  initialize: ->
    @render()

  render: ->
  	# Should be @model.get 'contacts'
    $(@el).html(@template(contacts: @model))