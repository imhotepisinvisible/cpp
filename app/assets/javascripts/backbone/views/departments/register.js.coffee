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
      data = {}
      data['department_administrator'] = @form.getValue()
      data['department_administrator[department_id]'] = @dept.id
      $.ajax
        url: "/department_administrators.json"
        data: data
        type: 'POST'
        success: (data) =>
          notify "success", "Registered", 2000
          setTimeout(
            -> Backbone.history.navigate("department_dashboard", trigger: true)
          , 2500)
        error: (data) =>
          if data.responseText
            errorlist = JSON.parse data.responseText
            for field, errors of errorlist.errors
              if field of @form.fields
                @form.fields[field].setError(errors.join ', ')
          notify "error", "Unable to register, please resolve issues below."

  redirect: (model) ->
    window.location = '/department_dashboard'
    window.location.reload(true)