CPP.Views.DepartmentAdministrator ||= {}

# Create new administrator
class CPP.Views.DepartmentAdministrator.Register extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/register']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  # Get department for administrator and create a new form based on the
  # administrator model
  initialize: (options) ->
    @dept = options.dept
    @form = new Backbone.Form
      model: @model
    .render()
    @render()

  # Show form and validate fields individually
  render: ->
    $(@el).html(@template(admin: @model, dept: @dept))
    super
    $('.form').append(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  # If form validates then create the new administrator on the server
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