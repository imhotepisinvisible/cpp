CPP.Views.Companies ||= {}

class CPP.Views.Companies.EditAdministrator extends CPP.Views.Base
  tagName: 'li'
  template: JST['backbone/templates/companies/edit_admin']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit-admin'   : 'edit'
    'click .btn-save-admin'   : 'save'
    'click .btn-delete-admin' : 'delete'
    'click .btn-cancel-admin' : 'cancel'

  initialize: ->
    @render()

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
    #Backbone.Validation.bind @form
    $(@el).find('.admin-form').html(@form.el)
    @

  edit: (e) ->
    console.log $(e.currentTarget)
    $(e.currentTarget).parent().parent().find('.btn-container').hide()
    $(e.currentTarget).parent().parent().find('.btn-save-admin').show()
    $(e.currentTarget).parent().parent().find('.btn-cancel-admin').show()
    $(e.currentTarget).parent().parent().find('.admin-display-container').hide()
    $(e.currentTarget).parent().parent().find('.admin-form').show()

  save: (e) ->
    if @form.validate() == null
      @form.commit()
      @model.save {},
        wait: true
        success: (_model) =>
          $(e.currentTarget).parent().find('.admin-name').html(@model.get('first_name') + ' ' + @model.get('last_name'))
          $(e.currentTarget).parent().find('.admin-email').html(@model.get 'email')
          @cancel(e)
          notify 'success', 'Administrator saved'
        error: ->
          notify 'error', 'Unable to save administrator'

  delete: (e) ->
    @model.destroy
      wait: true
      success: (model, response) =>
        notify "success", "Administrator deleted"
        $(@el).remove()
      error: (model, response) ->
        notify "error", "Administrator could not be deleted"

  cancel: (e) ->
    # Allow css to control style of btn-edit again
    $(e.currentTarget).parent().find('.btn-container').attr('style', '')

    $(e.currentTarget).parent().find('.btn-save-admin').hide()
    $(e.currentTarget).parent().find('.btn-cancel-admin').hide()
    $(e.currentTarget).parent().find('.admin-display-container').show()
    $(e.currentTarget).parent().find('.admin-form').hide()