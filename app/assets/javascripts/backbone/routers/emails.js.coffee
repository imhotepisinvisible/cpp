class CPP.Routers.Emails extends Backbone.Router
  routes:
      'emails'                            : 'index'
      'companies/:company_id/emails'      : 'indexCompany'
      'companies/:company_id/emails/new'  : 'new'
      'emails/:id/edit'                   : 'edit'
      'emails/:id'                        : 'view'

  # Emails for a specific company
  indexCompany: (company_id) ->
    emails = new CPP.Collections.Emails
    # new CPP.Views.Emails.Index collection: emails
    emails.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        emails.company = new CPP.Models.Company id: company_id
        emails.company.fetch
          success: ->
            new CPP.Views.Emails.Index collection: emails
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  # All emails
  index: ->
    emails = new CPP.Collections.Emails
    emails.fetch
      success: ->
        new CPP.Views.Emails.Index collection: emails
      error: ->
        notify "error", "Couldn't fetch emails"

  # New email for specific company
  new: (company_id) ->
    email = new CPP.Models.Email company_id: company_id, subject: "Subject", body: "Email body"
    email.collection = new CPP.Collections.Emails
    new CPP.Views.Emails.Edit model: email

  # Edit an email
  edit: (id) ->
    email = new CPP.Models.Email id: id
    email.fetch
      success: ->
        new CPP.Views.Emails.Edit model: email
      error: ->
        notify "error", "Couldn't fetch email"

  # View an email
  view: (id) ->
    email = new CPP.Models.Email id: id
    email.fetch
      success: ->
        email.company = new CPP.Models.Company id: email.get 'company_id'
        email.company.fetch
          success: ->
            new CPP.Views.Emails.View model: email
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch email"
