class CPP.Views.CompaniesView extends CPP.Views.Base
  el: "#app"
  template: JST['companies/view']
  
  initialize: ->
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    events_partial = new CPP.Views.EventsPartial
      el: $(@el).find('#events-partial')
      model: @model
      collection: @model.events

    placements_partial = new CPP.Views.PlacementsPartial
      el: $(@el).find('#placements-partial')
      model: @model
      collection: @model.placements

    emails_partial = new CPP.Views.EmailsPartial
      el: $(@el).find('#emails-partial')
      model: @model
      collection: @model.emails

    contacts_partial = new CPP.Views.ContactsPartial
      el: $(@el).find('#contacts-partial')
      company: @model
      company_id: @model.id
      limit: 3
    @

  activate: ->
    console.log "activate"


