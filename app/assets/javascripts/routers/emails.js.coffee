class CPP.Routers.Emails extends Backbone.Router
  routes:
      'emails'                            : 'index'
      'companies/:company_id/emails'      : 'indexCompany'
      'companies/:company_id/emails/new'  : 'new'
      'emails/:id/edit'                   : 'edit'
      'emails/:id'                        : 'view'

  indexCompany: (company_id) ->
    emails = new CPP.Collections.Emails
    # new CPP.Views.EmailsIndex collection: emails
    emails.fetch
      data:
        $.param({ company_id: company_id})
      success: ->
        emails.company = new CPP.Models.Company id: company_id
        emails.company.fetch
          success: ->
            new CPP.Views.EmailsIndex collection: emails
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch emails"

  index: ->
    emails = new CPP.Collections.Emails
    emails.fetch
      success: ->
        new CPP.Views.EmailsIndex collection: emails
      error: ->
        notify "error", "Couldn't fetch emails"

  new: (company_id) ->
    email = new CPP.Models.Email company_id: company_id
    email.collection = new CPP.Collections.Emails
    new CPP.Views.EmailsEdit model: email

  edit: (id) ->
    email = new CPP.Models.Email id: id
    email.fetch
      success: ->
        new CPP.Views.EmailsEdit model: email
      error: ->
        notify "error", "Couldn't fetch email"

  view: (id) ->
    email = new CPP.Models.Email id: id
    email.fetch
      success: ->
        email.company = new CPP.Models.Company id: email.get 'company_id'
        email.company.fetch
          success: ->
            new CPP.Views.EmailsView model: email
          error: ->
            notify "error", "Couldn't fetch company for email"
      error: ->
        notify "error", "Couldn't fetch email"
