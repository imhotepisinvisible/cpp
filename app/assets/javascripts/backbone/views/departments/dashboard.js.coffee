CPP.Views.Departments ||= {}

class CPP.Views.Departments.Dashboard extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/departments/dashboard']

  events: -> _.extend {}, CPP.Views.Base::events

  initialize: ->
    @initNotificationsForm()
    @render()

  render: ->
    $(@el).html(@template(department: @model))
    @renderNotificationsForm()

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