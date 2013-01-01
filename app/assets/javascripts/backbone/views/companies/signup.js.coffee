CPP.Views.CompanyAdministrator ||= {}

class CPP.Views.CompanyAdministrator.Signup extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/signup']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-submit': 'submit'

  initialize: (options) ->
    @login = options.login
    @company = options.company
    @form = new Backbone.Form
      model: @model
    .render()
    @render()

  render: ->
    $(@el).html(@template(companyAdministrator: @model, company: @company))
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
    @

  submit: (e) ->
    if @form.validate() == null
      @form.commit()
      deferreds = []
      if @company.isNew()
        # Save the new company
        deferreds.push(@company.save {},
              wait: true
              success: (model, response) =>
                # Attach new admin to new company
                @model.set 'company_id', model.get 'company_id'
              error: (model, response) =>
                notify 'error', 'Could not create company')
      else
        # Attach new admin to company
        @model.set 'company_id', @company.get 'id'

      $.when.apply($, deferreds).done(=>
        @model.save {},
          wait: true
          success: (model, response) =>
            notify "success", "Registered"
            @redirect()
            
          error: (model, response) =>
            if response.responseText
              errorlist = JSON.parse response.responseText
              for field, errors of errorlist.errors
                if field of @form.fields
                  @form.fields[field].setError(errors.join ', ')

            notify "error", "Unable to register, please resolve issues below."
      )

  redirect: ->
    if @login
      $.post '/sessions', { session: { email: @model.get('email'), password: @model.get('password') } }, (data) ->
        window.location = '/#/companies/' + @model.get('company_id') + '/edit'
        window.location.reload(true)
    else
      window.location = '/#/companies/' + @model.get('company_id') + '/edit'
      window.location.reload(true)