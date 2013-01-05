class CPP.Models.EventEmail extends CPP.Models.Email
  url: ->
    '/event_emails' + (if @isNew() then '' else '/' + @id)


class CPP.Collections.EventEmails extends CPP.Collections.Emails
  url: '/event_emails'
  model: CPP.Models.EventEmail
