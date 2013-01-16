CPP.Views.Emails ||= {}

class CPP.Views.Emails.Partial extends CPP.Views.Base
  template: JST['backbone/templates/emails/partial']

  # Defaults editable to false
  editable: false

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-add"      : "addEmail"
    "click .btn-view-all" : "viewCompaniesEmails"

  # Binds reset of collection to render in order to update view
  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @render()

  # For each email displays partial item
  render: () ->
    $(@el).html(@template(editable: @editable, emails: @collection))
    @$('#emails').html("")
    @collection.each (email) =>
      view = new CPP.Views.Emails.PartialItem
                  model: email
                  editable: @editable
      @$('#emails').append(view.render().el)
    @

  # Create new tagged email
  addEmail: ->
    Backbone.history.navigate("companies/" + getUserCompanyId() + "/tagged_emails/new", trigger: true)

  # View all emails for company
  viewCompaniesEmails: ->
    Backbone.history.navigate("companies/" + getUserCompanyId() + "/emails", trigger: true)
