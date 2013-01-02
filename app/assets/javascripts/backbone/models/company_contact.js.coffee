class CPP.Models.CompanyContact extends CPP.Models.Base
  url: ->
    '/company_contacts' + (if @isNew() then '' else '/' + @id)

  validation:
    first_name:
      required: true
    last_name:
      required: true
    role:
      required: true
    email:
      required: true
      pattern: 'email'

  schema:
    first_name:
      type: "Text"
      title: "First Name*"
    last_name:
      type: "Text"
      title: "Last Name*"
    email:
      type: "Text"
      title: "Email*"
    role:
      type: "Text"
      title: "Role*"

class CPP.Collections.CompanyContacts extends CPP.Collections.Base
  url: '/company_contacts'
  model: CPP.Models.CompanyContact
