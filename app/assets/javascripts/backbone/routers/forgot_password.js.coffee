class CPP.Routers.ForgotPassword extends Backbone.Router
  routes:
      'forgot_password': 'index'
      
  index: ->
    new CPP.Views.Users.ForgotPassword()
