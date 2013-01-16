CPP.Views.Departments ||= {}

# Settings page for department admin
class CPP.Views.Departments.Settings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/settings']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-name-save' : 'saveName'
    'click #btn-name-cancel' : 'cancelName'

  # Initialise department name changer form and render view
  initialize: ->
    @initNameForm()
    @render()

  # Render view template and password change view
  render: ->
    $(@el).html(@template(department: @model))
    @renderNameForm()

    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
    .render()

  # Form to change department model's name field
  initNameForm: ->
    @nameForm = new Backbone.Form
      model: @model
      schema:
        name:
          type: 'Text'
          title: 'Name'
    .render()

  # Show name form and validate on change
  renderNameForm: ->
    $('#name-form').html(@nameForm.el)
    Backbone.Validation.bind @nameForm
    @nameForm.on "change", =>
      @nameForm.validate()

  # If name is valid update name on server
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

  # Cancel editing by rendering old data
  cancelName: (e) ->
    @initNameForm()
    @renderNameForm()