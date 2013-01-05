class CPP.Routers.TaggedEmails extends Backbone.Router
  routes:
      'tagged_emails'                            : 'index'
      'companies/:company_id/tagged_emails'      : 'indexCompany'
      'companies/:company_id/tagged_emails/new'  : 'new'
      'tagged_emails/:id/edit'                   : 'edit'
      'tagged_emails/:id'                        : 'view'

  indexCompany: (company_id) ->
    if isStudent()
      window.history.back()
      return false
    emails = new CPP.Collections.TaggedEmails
    # new CPP.Views.Emails.Index collection: emails
    emails.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        emails.company = new CPP.Models.Company id: company_id
        emails.company.fetch
          success: ->
            new CPP.Views.Emails.Index collection: emails, type: "tagged"
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  index: ->
    if isStudent()
      window.history.back()
      return false
    emails = new CPP.Collections.TaggedEmails
    emails.fetch
      success: ->
        new CPP.Views.Emails.Index collection: emails, type: "tagged"
      error: ->
        notify "error", "Couldn't fetch emails"

  new: (company_id) ->
    if isStudent()
      window.history.back()
      return false
    email = new CPP.Models.TaggedEmail company_id: company_id, subject: "Subject", body: "Email body"
    email.collection = new CPP.Collections.TaggedEmails
    new CPP.Views.Emails.Edit model: email, type: "tagged"

  edit: (id) ->
    if isStudent()
      window.history.back()
      return false
    email = new CPP.Models.TaggedEmail id: id
    email.fetch
      success: ->
        new CPP.Views.Emails.Edit model: email, type: "tagged"
      error: ->
        notify "error", "Couldn't fetch email"

  view: (id) ->
    if isStudent()
      window.history.back()
      return false
    email = new CPP.Models.TaggedEmail id: id
    email.fetch
      success: ->
        email.company = new CPP.Models.Company id: email.get 'company_id'
        email.company.fetch
          success: ->
            new CPP.Views.Emails.View model: email, type: "tagged"
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch email"
