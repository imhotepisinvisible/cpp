CPP.Views.Company ||= {}

class CPP.Views.Company.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/signup_company']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  initialize: (options) ->
    @login = options.login
    @company = options.company
    @adminForm = new Backbone.Form
      model: @model
    .render()

    if isDepartmentAdmin()
      schema = @company.schema()
      delete schema["departments"]

      @company.set('departments', [CPP.CurrentUser.get 'department_id'])
      @company.schema = -> schema

    @companyForm = new Backbone.Form
      model: @company
    .render()
    @render()

  render: ->
    $(@el).html(@template(admin: @model, company: @company))
    super
    $('#admin-form').append(@adminForm.el)
    $('#company-form').append(@companyForm.el)
    Backbone.Validation.bind @adminForm
    validateField(@adminForm, field) for field of @adminForm.fields
    Backbone.Validation.bind @companyForm
    validateField(@companyForm, field) for field of @companyForm.fields
    @

  submit: (e) ->
    companyValid = @companyForm.validate()
    if @adminForm.validate() == null and companyValid == null
      @adminForm.commit()
      if @company.isNew()
        @companyForm.commit()
        @company.save {},
          wait: true
          forceUpdate: true
          success: (model, response) =>
            # Attach new admin to new company
            @saveAdmin()
          error: (model, response) =>
            if response.responseText
                errorlist = JSON.parse response.responseText
                for field, errors of errorlist.errors
                  if field of @companyForm.fields
                    @companyForm.fields[field].setError(_.uniq(errors).join ', ')
            notify 'error', 'Could not create company'
      else
        @saveAdmin()

  saveAdmin: (e) ->
    @model.set 'company_id', @company.get 'id'
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
          if field of @adminForm.fields
            @adminForm.fields[field].setError(_.uniq(errors).join ', ')
      notify "error", "Unable to register, please resolve issues below."

  redirect: (model) ->
    go = ->
      window.location = '/#/companies/' + model.get('company_id') + '/edit'
      window.location.reload(true)

    if @login
      $.post '/sessions', { session: { email: model.get('email'), password: model.get('password') } }, go
    else
      go()