class CPP.Routers.EventEmails extends Backbone.Router
  routes:
      'event_emails'                            : 'index'
      'companies/:company_id/event_emails'      : 'indexCompany'
      'events/:event_id/emails'                 : 'indexEvent'
      'events/:event_id/email_attendees'        : 'new'
      'event_emails/:id/edit'                  : 'edit'
      'event_emails/:id'                       : 'view'

  indexCompany: (company_id) ->
    emails = new CPP.Collections.EventEmails
    # new CPP.Views.Emails.Index collection: emails
    emails.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        emails.company = new CPP.Models.Company id: company_id
        emails.company.fetch
          success: ->
            new CPP.Views.Emails.Index collection: emails, type: "event"
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  indexEvent: (event_id) ->
    emails = new CPP.Collections.EventEmails
    # new CPP.Views.Emails.Index collection: emails
    emails.fetch
      data:
        $.param({ event_id: event_id})
      success: ->
        emails.event = new CPP.Models.Event id: event_id
        emails.event.fetch
          success: ->
            new CPP.Views.Emails.Index collection: emails, type: "event"
          error: ->
            notify "error", "Couldn't fetch event for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  index: ->
    emails = new CPP.Collections.EventEmails
    emails.fetch
      success: ->
        new CPP.Views.Emails.Index collection: emails, type: "event"
      error: ->
        notify "error", "Couldn't fetch emails"

  new: (event_id) ->
    event = new CPP.Models.Event id: event_id
    event.fetch
      success: ->
        company = event.get 'company_id'
        email = new CPP.Models.EventEmail company_id: company, event_id: event_id, subject: "Subject", body: "Email body"
        email.collection = new CPP.Collections.EventEmails
        new CPP.Views.Emails.Edit model: email, type: "event"
      error: ->
        notify "error", "Couldn't fetch event"

  edit: (id) ->
    email = new CPP.Models.EventEmail id: id
    email.fetch
      success: ->
        new CPP.Views.Emails.Edit model: email, type: "event"
      error: ->
        notify "error", "Couldn't fetch email"

  view: (id) ->
    email = new CPP.Models.EventEmail id: id
    email.fetch
      success: ->
        email.company = new CPP.Models.Company id: email.get 'company_id'
        email.company.fetch
          success: ->
            new CPP.Views.Emails.View model: email, type: "event"
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch email"
