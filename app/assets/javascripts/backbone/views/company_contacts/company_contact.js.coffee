CPP.Views.Contacts ||= {}

class CPP.Views.CompanyContact extends CPP.Views.Base
  tagName: "li"
  className: "contact-display-container"

  template: JST['backbone/templates/company_contacts/contact']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .btn-edit'   : 'edit'
    'click .btn-save'   : 'save'
    'click .btn-delete' : 'delete'
    'click .btn-cancel' : 'cancel'
    'drop'              : 'drop'

  initialize: (options) ->
    # Edit individual contact
    @model.bind 'change', @render, @
    @render

  render: ->
    $(@el).html(@template({contact: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))}))
    @form = new Backbone.Form(model: @model, template: 'standardForm').render()
    $(@el).find('.contact-form').html(@form.el)
    Backbone.Validation.bind @form
    validateField(@form, field) for field of @form.fields
    @

  drop: (event, index) ->
    # Event for placing draggable
    $(@el).trigger('update-sort', [@model, index]);

  edit: (e) ->
    # Show the edit form
    $(e.currentTarget).parent().parent().find('.btn-container').hide()
    $(e.currentTarget).parent().parent().find('.btn-save').show()
    $(e.currentTarget).parent().parent().find('.btn-cancel').show()
    $(e.currentTarget).parent().parent().removeClass('hoverable')
    $(e.currentTarget).parent().parent().find('.contact-display-container').hide()
    $(e.currentTarget).parent().parent().find('.contact-form').show()

  save: (e) ->
    # Save the company contact
    index = $(e.currentTarget).parent().attr('id')
    if @form.validate() == null
      @form.commit()
      @form.model.save {},
        wait: true
        forceUpdate: true
        success: (_model) =>
          $(e.currentTarget).parent().find('.contact-role').html(@model.get 'role')
          $(e.currentTarget).parent().find('.contact-name').html(@model.get('first_name') + ' ' + @model.get('last_name'))
          $(e.currentTarget).parent().find('.contact-email').html(@model.get 'email')
          notify 'success', 'Contact saved'
        error: ->
          notify 'error', 'Unable to save contact'

      @cancel(e)

  delete: (e) ->
    # Delete the company contact
    index = $(e.currentTarget).parent().parent().attr('id')
    @model.destroy
      wait: true
      success: (model, response) =>
        notify "success", "Contact deleted"
      error: (model, response) ->
        notify "error", "Contact could not be deleted"

  cancel: (e) ->
    # Allow css to control style of btn-edit again
    $(e.currentTarget).parent().find('.btn-container').attr('style', '')

    $(e.currentTarget).parent().find('.btn-save').hide()
    $(e.currentTarget).parent().find('.btn-cancel').hide()
    $(e.currentTarget).parent().addClass('hoverable')
    $(e.currentTarget).parent().find('.contact-display-container').show()
    $(e.currentTarget).parent().find('.contact-form').hide()
