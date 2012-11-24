class CPP.Views.LoginUser extends CPP.Views.Base
  el: ".navbar-form"
  events: -> _.extend {}, CPP.Views.Base::events,
    "click .login-submit": "saveForm"

  initialize: ->
    @model = new CPP.Models.LoginUser()
    #@render()

  render: ->

    # $button = $("<button class=\"btn\" type=\"button\" name=\"login\" id=\"formButton\">Login</button>")
    # @form = new Backbone.Form(model: @model, template: "loginform")
    # @$el.append @form.render().el
    # @$el.append $button
    # @

  saveForm: ->
    #@form.commit()
    @model.set("email", $('#session_email').val())
    @model.set("password", $('#session_password').val())
    @model.save {},
      wait: true
      success: (model, response) =>
        notify "success", "Logged In Succesfully"
        @undelegateEvents()
        Backbone.history.navigate("companies", trigger: true)
      error: (model, response) =>
        notify "error", "Password fail. Retry"
