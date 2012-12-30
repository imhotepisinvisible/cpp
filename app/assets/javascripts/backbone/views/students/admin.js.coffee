CPP.Views.Students ||= {}

class CPP.Views.Students.Admin extends CPP.Views.Base
  el: "#app"

  template: JST['backbone/templates/students/admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-save': 'save'

  initialize: ->
    if !(isDepartmentAdmin())
      Backbone.history.navigate("/", trigger: true)
      return
    @form = new Backbone.Form
      model: @model
      schema:
        first_name:
          title: 'First Name'
          type: 'Text'
        last_name:
          title: 'Last Name'
          type: 'Text'
        year:
          title: 'Year'
          type: 'Number'
        degree:
          title: 'Degree'
          type: 'Text'
        bio:
          title: 'About Me'
          type: 'TextArea'
        looking_for:
          title: 'Looking for'
          type: 'Select'
          options: ['Looking for an Industrial Placement',
                    'Looking for a Summer Placement',
                    {val: '', label: 'Not looking for anything'}]
    .render()
    @render()

  render: ->
    $(@el).html(@template(student: @model, editable: true))
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
          notify "success", "Student saved"
          window.history.back()
          @undelegateEvents()
        error: (model, response) =>
          errorlist = JSON.parse response.responseText
          if response.errors
            window.displayErrorMessages response.errors
          else
            notify 'error', 'Unable to save student'
