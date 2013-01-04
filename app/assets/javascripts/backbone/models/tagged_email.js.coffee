class CPP.Models.TaggedEmail extends CPP.Models.Email
  url: ->
    '/tagged_emails' + (if @isNew() then '' else '/' + @id)

class CPP.Collections.TaggedEmails extends CPP.Collections.Emails
  url: '/tagged_emails'
  model: CPP.Models.TaggedEmail
