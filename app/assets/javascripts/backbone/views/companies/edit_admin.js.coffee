CPP.Views.Companies ||= {}

class CPP.Views.Companies.EditAdministrator extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/companies/edit_admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit-admin'   : 'edit'
    'click .btn-save-admin'   : 'save'
    'click .btn-delete-admin' : 'delete'
    'click .btn-cancel-admin' : 'cancel'

  # Company admin edit partial
  initialize: ->
    @render()

  # Render the company admin edit partial
  render: ->
    $(@el).html(@template(admin: @model))
    # Form to modify company administrator
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

  # Show the edit partial
  edit: (e) ->
    $(e.currentTarget).parent().parent().find('.btn-container').hide()
    $(e.currentTarget).parent().parent().find('.btn-save-admin').show()
    $(e.currentTarget).parent().parent().find('.btn-cancel-admin').show()
    $(e.currentTarget).parent().parent().find('.admin-display-container').hide()
    $(e.currentTarget).parent().parent().find('.admin-form').show()

  # Save the company admin
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

  # Delete the company admin
  delete: (e) ->
    @model.destroy
      wait: true
      success: (model, response) =>
        notify "success", "Administrator deleted"
        $(@el).remove()
      error: (model, response) ->
        notify "error", "Administrator could not be deleted"

  # Hide the edit partial
  cancel: (e) ->
    # Allow css to control style of btn-edit again
    $(e.currentTarget).parent().find('.btn-container').attr('style', '')
    $(e.currentTarget).parent().find('.btn-save-admin').hide()
    $(e.currentTarget).parent().find('.btn-cancel-admin').hide()
    $(e.currentTarget).parent().find('.admin-display-container').show()
    $(e.currentTarget).parent().find('.admin-form').hide()