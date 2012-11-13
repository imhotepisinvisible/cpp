class CPP.Views.StudentsSignup extends CPP.Views.Base
  el: "#app"
  template: JST['students/signup']

  events:
    'click .btn-submit': 'submitEvent'

  initialize: ->
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
          Backbone.history.navigate('students/' + @model.get('id'), trigger: true)
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          console.log @form.fields
          for field, errors of errorlist.errors
            if field of @form.fields
              @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to register, please resolve issues below."
