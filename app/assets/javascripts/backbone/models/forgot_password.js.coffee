class CPP.Models.ForgotPassword extends Backbone.Model
  url: ->
    '/users/change_password'

  validation:
    email:
      required: true
      pattern: 'email'

  schema: ->
    email:
      type: "Text"
      title: "Email"
