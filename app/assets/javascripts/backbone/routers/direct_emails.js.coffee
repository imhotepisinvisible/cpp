class CPP.Routers.DirectEmails extends Backbone.Router
  routes:
      'direct_emails'                           : 'index'
      'companies/:company_id/direct_emails'     : 'indexCompany'
      'students/:student_id/emails'             : 'indexStudent'
      'students/:student_id/email'              : 'new'
      'direct_emails/:id/edit'                  : 'edit'
      'direct_emails/:id'                       : 'view'

  indexCompany: (company_id) ->
    emails = new CPP.Collections.DirectEmails
    # new CPP.Views.Emails.Index collection: emails
    emails.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        emails.company = new CPP.Models.Company id: company_id
        emails.company.fetch
          success: ->
            new CPP.Views.Emails.Index collection: emails, type: "direct"
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  indexStudent: (student_id) ->
    emails = new CPP.Collections.DirectEmails
    # new CPP.Views.Emails.Index collection: emails
    emails.fetch
      data:
        $.param({ student_id: student_id, company_id: userId()})
      success: ->
        emails.student = new CPP.Models.Student id: student_id
        emails.student.fetch
          success: ->
            new CPP.Views.Emails.Index collection: emails, type: "direct"
          error: ->
            notify "error", "Couldn't fetch Student for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  index: ->
    emails = new CPP.Collections.DirectEmails
    emails.fetch
      success: ->
        new CPP.Views.Emails.Index collection: emails, type: "direct"
      error: ->
        notify "error", "Couldn't fetch emails"

  new: (student_id) ->
    student = new CPP.Models.Student id: student_id
    student.fetch
      success: ->
        company = getUserCompanyId()
        email = new CPP.Models.DirectEmail company_id: company, student_id: student_id, subject: "Subject", body: "Email body"
        email.collection = new CPP.Collections.DirectEmails
        new CPP.Views.Emails.Edit model: email, type: "direct"
      error: ->
        notify "error", "Couldn't fetch event"

  edit: (id) ->
    email = new CPP.Models.DirectEmail id: id
    email.fetch
      success: ->
        new CPP.Views.Emails.Edit model: email, type: "direct"
      error: ->
        notify "error", "Couldn't fetch email"

  view: (id) ->
    email = new CPP.Models.DirectEmail id: id
    email.fetch
      success: ->
        email.company = new CPP.Models.Company id: email.get 'company_id'
        email.company.fetch
          success: ->
            new CPP.Views.Emails.View model: email, type: "direct"
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch email"
