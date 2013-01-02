CPP.Views.Departments ||= {}

class CPP.Views.Departments.Settings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-name-save' : 'saveName'
    'click #btn-name-cancel' : 'cancelName'

  initialize: ->
    @initNameForm()
    @render()

  render: ->
    $(@el).html(@template(department: @model))
    @renderNameForm()

    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
    .render()

  initNameForm: ->
    @nameForm = new Backbone.Form
      model: @model
      schema:
        name:
          type: 'Text'
          title: 'Name'
    .render()

  renderNameForm: ->
    $('#name-form').html(@nameForm.el)
    Backbone.Validation.bind @nameForm
    @nameForm.on "change", =>
      @nameForm.validate()

  saveName: (e) ->
    if @nameForm.validate() == null
      @nameForm.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) ->
          notify 'success', 'Department name updated'
        error: (model, response) ->
          notify 'error', 'Unable to save department name'

  cancelName: (e) ->
    @initNameForm()
    @renderNameForm()