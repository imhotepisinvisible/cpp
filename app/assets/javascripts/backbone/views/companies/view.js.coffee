class CPP.Views.CompaniesView extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/view']

  initialize: ->
    if isStudent()
      @model.record_stat_view()
    @render()

  render: ->
    $(@el).html(@template(company: @model))

    events_partial = new CPP.Views.Events.Partial
      el: $(@el).find('#events-partial')
      company: @model
      collection: @model.events

    placements_partial = new CPP.Views.Placements.Partial
      el: $(@el).find('#placements-partial')
      company: @model
      collection: @model.placements

    contacts_partial = new CPP.Views.Contacts.Partial
      el: $(@el).find('#contacts-partial')
      company: @model
      company_id: @model.id
      limit: 3

    if isAdmin()
      emails_partial = new CPP.Views.TaggedEmails.Partial
        el: $(@el).find('#emails-partial')
        company: @model
        collection: @model.tagged_emails

      new CPP.Views.Companies.StatsPartial
        company: @model

    @

  activate: ->
    console.log "activate"


