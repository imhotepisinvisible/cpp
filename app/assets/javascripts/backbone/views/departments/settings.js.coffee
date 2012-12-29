CPP.Views.Departments ||= {}

class CPP.Views.Departments.Settings extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/settings']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-notifications-save' : 'saveNotifications'
    'click #btn-notifications-cancel' : 'cancelNotifications'

  initialize: ->
    @initNotificationsForm()
    @render()

  render: ->
    $(@el).html(@template(department: @model))
    @renderNotificationsForm()

    new CPP.Views.Users.ChangePassword
      el: $(@el).find('#change-password')
      model: @model
    .render()

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

  saveNotifications: (e) ->
    if @notificationsForm.validate() == null
      @notificationsForm.commit()
      @model.save {},
        wait: true
        success: (model, response) ->
          notify 'success', 'Company notifications updated'
        error: (model, response) ->
          console.log response

  cancelNotifications: (e) ->
    @initNotificationsForm()
    @renderNotificationsForm()