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
      model: [{name: 'Johnny Robinson', role: 'Developer', email: 'jon_robinson@google.biz'},
              {name: 'Daniel Simonson', role: 'Recruiter', email: 'dan.simonson@google.biz'}]
    @

  activate: ->
    console.log "activate"


