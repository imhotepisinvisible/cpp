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
    if @adminForm.validate() == null and @companyForm.validate() == null
      @adminForm.commit()
      @companyForm.commit()
      @company.save {},
        wait: true
        forceUpdate: true
        success: (model, response) =>
          # Attach new admin to new company
          @model.set 'company_id', model.get 'id'
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
                  @adminForm.fields[field].setError(errors.join ', ')

            notify "error", "Unable to register, please resolve issues below."
        error: (model, response) =>
          if response.responseText
              errorlist = JSON.parse response.responseText
              for field, errors of errorlist.errors
                if field of @companyForm.fields
                  @companyForm.fields[field].setError(errors.join ', ')
          notify 'error', 'Could not create company'

  redirect: (model) ->
    go = ->
      window.location = '/#/companies/' + model.get('company_id') + '/edit'
      window.location.reload(true)

    if @login
      $.post '/sessions', { session: { email: model.get('email'), password: model.get('password') } }, go
    else
      go()