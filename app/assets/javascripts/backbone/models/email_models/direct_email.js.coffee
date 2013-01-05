class CPP.Models.DirectEmail extends CPP.Models.Email
  url: ->
    '/direct_emails' + (if @isNew() then '' else '/' + @id)
  

class CPP.Collections.DirectEmails extends CPP.Collections.Emails
  url: '/direct_emails'
  model: CPP.Models.DirectEmail
