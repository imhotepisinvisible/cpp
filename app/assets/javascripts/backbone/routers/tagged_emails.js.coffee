class CPP.Routers.TaggedEmails extends Backbone.Router
  routes:
      'tagged_emails'                            : 'index'
      'companies/:company_id/tagged_emails'      : 'indexCompany'
      'companies/:company_id/tagged_emails/new'  : 'new'
      'tagged_emails/:id/edit'                   : 'edit'
      'tagged_emails/:id'                        : 'view'

  indexCompany: (company_id) ->
    emails = new CPP.Collections.TaggedEmails
    # new CPP.Views.TaggedEmailsIndex collection: emails
    emails.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        emails.company = new CPP.Models.Company id: company_id
        emails.company.fetch
          success: ->
            new CPP.Views.TaggedEmailsIndex collection: emails
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  index: ->
    emails = new CPP.Collections.TaggedEmails
    emails.fetch
      success: ->
        new CPP.Views.TaggedEmailsIndex collection: emails
      error: ->
        notify "error", "Couldn't fetch emails"

  new: (company_id) ->
    email = new CPP.Models.TaggedEmail company_id: company_id, subject: "Subject", body: "Email body"
    email.collection = new CPP.Collections.TaggedEmails
    new CPP.Views.TaggedEmailsEdit model: email

  edit: (id) ->
    email = new CPP.Models.TaggedEmail id: id
    email.fetch
      success: ->
        new CPP.Views.TaggedEmailsEdit model: email
      error: ->
        notify "error", "Couldn't fetch email"

  view: (id) ->
    email = new CPP.Models.TaggedEmail id: id
    email.fetch
      success: ->
        email.company = new CPP.Models.Company id: email.get 'company_id'
        email.company.fetch
          success: ->
            new CPP.Views.TaggedEmailsView model: email
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch email"
