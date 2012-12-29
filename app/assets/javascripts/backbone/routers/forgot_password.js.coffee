class CPP.Routers.ForgotPassword extends Backbone.Router
  routes:
      'forgot_password': 'index'
      
  index: ->
    model = new CPP.Models.ForgotPassword
    new CPP.Views.Users.ForgotPassword model: model
