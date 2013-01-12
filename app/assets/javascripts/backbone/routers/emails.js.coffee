class CPP.Routers.Emails extends Backbone.Router
  routes:
      'emails'                            : 'index'
      'companies/:company_id/emails'      : 'indexCompany'
      'companies/:company_id/emails/new'  : 'new'
      'emails/:id/edit'                   : 'edit'
      'emails/:id'                        : 'view'

  indexCompany: (company_id) ->
    # Emails for a specific company
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

  index: ->
    # All emails
    emails = new CPP.Collections.Emails
    emails.fetch
      success: ->
        new CPP.Views.Emails.Index collection: emails
      error: ->
        notify "error", "Couldn't fetch emails"

  new: (company_id) ->
    # New email for specific company
    email = new CPP.Models.Email company_id: company_id, subject: "Subject", body: "Email body"
    email.collection = new CPP.Collections.Emails
    new CPP.Views.Emails.Edit model: email

  edit: (id) ->
    # Edit an email
    email = new CPP.Models.Email id: id
    email.fetch
      success: ->
        new CPP.Views.Emails.Edit model: email
      error: ->
        notify "error", "Couldn't fetch email"

  view: (id) ->
    # View an email
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
