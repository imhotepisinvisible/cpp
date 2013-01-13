CPP.Views.Emails ||= {}

# Email view
class CPP.Views.Emails.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/emails/index']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-add"      : "addEmail"
    'click .company-logo-header' : 'viewCompany'

  # Binds actions to model so that backbone view re-renders on them
  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    @collection.bind 'destroy', @render, @
    @render()

  # Gets type of email and creates template based on that type
  # Fetches Company for each email and renders Email item
  render: ->
    type = @options.type
    $(@el).html(@template(emails: @collection, type: type))

    # TODO: Can we just use @collection.company.id to fetch company only once?
    @collection.each (email) =>
      email.company = new CPP.Models.Company id: email.get("company_id")
      email.company.fetch
        success: ->
          # Render the email if we can get its company
          view = new CPP.Views.Emails.Item model: email, type: type
          @$('#emails').append(view.render().el)
        error: ->
          notify "error", "Couldn't fetch company for email"
    @

  # Navigates to tagged emails to events emails based on type
  addEmail: ->
    switch @options.type
      when "tagged" then Backbone.history.navigate("companies/" + getUserCompanyId() + "/tagged_emails/new", trigger: true)
      when "event" then Backbone.history.navigate("events/" + @collection.event.id + "/email_attendees", trigger: true)

  # Navigates to company view
  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)

