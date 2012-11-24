class CPP.Models.CompanyContact extends Backbone.Model
  url: ->
    '/company_contacts' + (if @isNew() then '' else '/' + @id)

  validation:
    name:
      required: true
    email:
      required: true
      pattern: 'email'

  schema:
    name:
      type: "Text"
      title: "Full Name"
    email:
      type: "Text"
      title: "Email"
