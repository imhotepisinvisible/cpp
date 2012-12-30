CPP.Views.Students ||= {}

class CPP.Views.Students.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/students/signup']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submitEvent'

  initialize: (options) ->
    @login = options.login
    @form = new Backbone.Form(model: @model).render()
    @render()

  render: ->
    $(@el).html(@template(student: @model))
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
    @

  submitEvent: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Registered"
          if @login
            $.post '/sessions', { session: { email: @model.get('email'), password: @model.get('password') } }, (data) ->
              window.location = '/#/students/' + model.get('id') + '/edit'
              window.location.reload(true)
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          for field, errors of errorlist.errors
            if field of @form.fields
              @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to register, please resolve issues below."
