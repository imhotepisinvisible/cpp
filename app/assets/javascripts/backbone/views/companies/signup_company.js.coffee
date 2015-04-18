CPP.Views.Company ||= {}

class CPP.Views.Company.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/signup_company']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  # Company and company administrator signup
  initialize: (options) ->
    @login = options.login
    @company = options.company
    @adminForm = new Backbone.Form
      model: @model
    .render()

    # Don't give department options if department admin is signing up a company
    if isDepartmentAdmin()
      schema = @company.schema()
      delete schema["departments"]

      @company.set('departments', [CPP.CurrentUser.get 'department_id'])
      @company.schema = -> schema

    @companyForm = new Backbone.Form
      model: @company
    .render()
    @render()

  # Render company signup page
  render: ->
    $(@el).html(@template(admin: @model, company: @company))
    super
    # Two forms, one for admin and other for company
    $('#admin-form').append(@adminForm.el)
    $('#company-form').append(@companyForm.el)
    Backbone.Validation.bind @adminForm
    validateField(@adminForm, field) for field of @adminForm.fields
    Backbone.Validation.bind @companyForm
    validateField(@companyForm, field) for field of @companyForm.fields
    @

  # Validate both forms
  submit: (e) ->
    companyValid = @companyForm.validate()
    if @adminForm.validate() == null and companyValid == null
      # Save company first
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

  # Save company administrator
  saveAdmin: (e) ->
    if @adminForm.validate() == null
      data = {}
      data['company_administrator'] = @adminForm.getValue()
      data['company_administrator[company_id]'] = @company.get 'id'
      $.ajax
        url: "/company_administrators.json"
        data: data
        type: 'POST'
        success: (data) =>
          notify "success", "Registered", 2000
          setTimeout(
            -> Backbone.history.navigate("companies/" + _this.company.get('id') + "/edit", trigger: true)
          , 2500)
        error: (data) =>
          if data.responseText
            errorlist = JSON.parse data.responseText
            for field, errors of errorlist.errors
              if field of @adminForm.fields
                @adminForm.fields[field].setError(errors.join ', ')
          notify "error", "Unable to register, please resolve issues below."

  # Redirect to edit page on signup
  redirect: (model) ->
    go = ->
      Backbone.history.navigate("/companies/" + model.get('company_id') + "/edit", trigger: true)

    if @login
      # Log in as new company admin, then navigate to company edit page
      $.post '/sessions', { session: { email: model.get('email'), password: model.get('password') } }, go
    else
      # Do not log in, navigate to company edit page
      go()