CPP.Views.Departments ||= {}

class CPP.Views.Departments.Dashboard extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/dashboard']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-notifications-save': 'saveNotifications'
    'click #btn-notifications-cancel': 'cancelNotifications'

  initialize: ->
    @initNotificationsForm()
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

  initNotificationsForm: ->
    @notificationsForm = new Backbone.Form
      model: @model
      schema:
        settings_notifier_placement:
          type: 'TextArea'
          title: 'New Placement Notification'
        settings_notifier_event:
          type: 'TextArea'
          title: 'New Event Notification'
    .render()

  renderNotificationsForm: ->
    $('#notifications-form').html(@notificationsForm.el)
    Backbone.Validation.bind @notificationsForm
    @notificationsForm.on "change", =>
      @notificationsForm.validate()

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

  cancelNotifications: (e) ->
    @initNotificationsForm()
    @renderNotificationsForm()