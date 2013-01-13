CPP.Views.Departments ||= {}

# In place department edit for dashboard
class CPP.Views.Departments.EditAdministrator extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/departments/edit_admin']

  # Bind event listeners 
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit-admin'   : 'edit'
    'click .btn-save-admin'   : 'save'
    'click .btn-delete-admin' : 'delete'
    'click .btn-cancel-admin' : 'cancel'

  initialize: ->
    @render()

  # Creates an inplace edit form based on the schema that saves to model
  # For each field performs individual validation
  render: ->
    $(@el).html(@template(admin: @model))
    @form = new Backbone.Form
      model: @model
      template: 'standardForm'
      schema:
        first_name:
          type: "Text"
          title: "First Name"
        last_name:
          type: "Text"
          title: "Last Name"

    .render()
    $(@el).find('.admin-form').html(@form.el)
    Backbone.Validation.bind @form
    
    validateField(@form, field) for field of @form.fields
    @

  # Hide edit button and show edit form
  edit: (e) ->
    container = $(e.currentTarget).parent().parent()
    container.find('.btn-container').hide()
    @toggleForm container, true

  # Save admin if form validates correctly.
  # Force updates due to backbone clearing model and re-validating
  # On success show edited admin
  save: (e) ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        forceUpdate: true
        success: (_model) =>
          $(e.currentTarget).parent().find('.admin-name').html(@model.get('first_name') + ' ' + @model.get('last_name'))
          $(e.currentTarget).parent().find('.admin-email').html(@model.get 'email')
          @cancel(e)
          notify 'success', 'Administrator saved'
        error: ->
          notify 'error', 'Unable to save administrator'

  # Delete admin
  delete: (e) ->
    @model.destroy
      wait: true
      success: (model, response) =>
        notify "success", "Administrator deleted"
        $(@el).remove()
      error: (model, response) ->
        notify "error", "Administrator could not be deleted"

  # Hide form
  cancel: (e) ->
    container = $(e.currentTarget).parent()
    # Allow css to control style of btn-edit again
    container.find('.btn-container').attr('style', '')
    @toggleForm container, false

  # Toggle admin edit form on/off show
  toggleForm: (container, show) ->
    container.find('.btn-save-admin').toggle(show)
    container.find('.btn-cancel-admin').toggle(show)
    container.find('.admin-display-container').toggle(!show)
    container.find('.admin-form').toggle(show)