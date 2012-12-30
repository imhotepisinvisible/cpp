CPP.Views.Companies ||= {}

class CPP.Views.Companies.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/companies/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'

  initialize: ->
    @form = new Backbone.Form
      model: @model
      schema:
        name:
          title: 'Name'
          type: 'Text'
        description:
          title: 'Description'
          type: 'TextArea'
    .render()
    @render()

  render: ->
    $(@el).html(@template(company: @model))
    # Super called as extending we are extending CPP.Views.Base
    super
    $('.form').append(@form.el)
    @form.on "change", =>
      @form.validate()
  @

  save: ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (model, response) =>
          notify "success", "Company saved"
          window.history.back()
          @undelegateEvents()
        error: (model, response) =>
          try
            errorlist = JSON.parse response.responseText
            if response.errors
              window.displayErrorMessages response.errors
            else
              notify 'error', 'Unable to save company'
          catch err
            notify 'error', response.responseText
          
