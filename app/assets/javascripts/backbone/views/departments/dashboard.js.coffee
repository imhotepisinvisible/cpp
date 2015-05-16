CPP.Views.Departments ||= {}

# Department dashboard, viewed on signing in and displays useful
# infortmation to department administrators.
class CPP.Views.Departments.Dashboard extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/dashboard']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-notifications-save': 'saveNotifications'
    'click #btn-notifications-cancel': 'cancelNotifications'

  initialize: ->
    @initNotificationsForm()
    @model.bind 'change', @cancelNotifications, @
    @render()

  render: ->
    $(@el).html(@template(department: @model))
    @renderNotificationsForm()

    new CPP.Views.Departments.Approvals
      el: $(@el).find('#pending-approvals')
      model: @model

    new CPP.Views.Departments.EditAdministrators
      el: $(@el).find('#edit-admins')
      model: @model

  # Create event/placement notification form, values inputted are to
  # be displayed to companies on creating new events/placements.
  initNotificationsForm: ->
    @notificationsForm = new Backbone.Form
      model: @model
      schema:
        settings_notifier_placement:
          type: 'TextArea'
          title: 'New Placement Notification'
          editorAttrs: { rows: 5 }
          editorClass: "input-xlarge"
        settings_notifier_event:
          type: 'TextArea'
          title: 'New Event Notification'
          editorAttrs: { rows: 5 }
          editorClass: "input-xlarge"
    .render()

  # Displays notificaiton form and sets up validation on change
  renderNotificationsForm: ->
    $('#notifications-form').html(@notificationsForm.el)
    Backbone.Validation.bind @notificationsForm
    @notificationsForm.on "change", =>
      @notificationsForm.validate()

  # Saves notifications if validation passes
  saveNotifications: (e) ->
    if @notificationsForm.validate() == null
      @notificationsForm.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (model, response) ->
          notify 'success', 'Company notifications updated'
        error: (model, response) ->
          notify 'error', 'Cannot update company notifications'

  # Render previous notifications
  cancelNotifications: (e) ->
    @initNotificationsForm()
    @renderNotificationsForm()
