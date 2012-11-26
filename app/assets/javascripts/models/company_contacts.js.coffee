class CPP.Models.CompanyContact extends Backbone.Model
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
      title: "First Name"
    last_name:
      type: "Text"
      title: "Last Name"
    email:
      type: "Text"
      title: "Email"
    role:
      type: "Text"
      title: "Role"
