CPP.Views.DepartmentAdministrator ||= {}

class CPP.Views.DepartmentAdministrator.Register extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/register']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  initialize: (options) ->
    @dept = options.dept
    @form = new Backbone.Form
      model: @model
    .render()
    @render()

  render: ->
    $(@el).html(@template(admin: @model, dept: @dept))
    super
    $('.form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  submit: (e) ->
    if @form.validate() == null
      @form.commit()
      @model.set 'department_id', @dept.id
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          notify "success", "Registered"
          @redirect(model)
          
        error: (model, response) =>
          if response.responseText
            errorlist = JSON.parse response.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')

          notify "error", "Unable to register, please resolve issues below."
      

  redirect: (model) ->
    window.location = '/#department_dashboard'
    window.location.reload(true)