class CPP.Views.ContactsPartialEdit extends CPP.Views.Base
  template: JST['company_contacts/contacts_edit']

  events:
    'click .btn-edit' : 'edit'
    'click .btn-save' : 'save'
    'click .btn-delete' : 'delete'
    'click .btn-cancel' : 'cancel'

  initialize: ->
    @render()

    @forms = []

    for contact, index in @collection.models
      @forms.push(new Backbone.Form(model: contact, template: 'standardForm').render())
      Backbone.Validation.bind @forms[index]
      $(@el).find('#' + index + '.item').find('.contact-form').html(@forms[index].el)

  render: ->
    $(@el).html(@template(contacts: @collection))

  edit: (e) ->
    $(e.currentTarget).parent().parent().find('.btn-edit').hide()
    $(e.currentTarget).parent().parent().find('.btn-save').show()
    $(e.currentTarget).parent().parent().find('.btn-cancel').show()
    $(e.currentTarget).parent().parent().removeClass('hoverable')
    $(e.currentTarget).parent().parent().find('.contact-display-container').hide()
    $(e.currentTarget).parent().parent().find('.contact-form').show()

  save: (e) ->
    index = $(e.currentTarget).parent().attr('id')
    model = @collection.at(index)

    if @forms[index].validate() == null
      @forms[index].commit()
      @forms[index].model.save {},
        wait: true
        success: (_model) =>
          $(e.currentTarget).parent().find('.contact-role').html(_model.get 'role')
          $(e.currentTarget).parent().find('.contact-name').html(_model.get 'first_name')
          $(e.currentTarget).parent().find('.contact-email').html(_model.get 'email')
          notify 'success', 'Contact saved'
        error: ->
          notify 'error', 'Unable to save contact'

      @cancel(e)

  cancel: (e) ->
    # Allow css to control style of btn-edit again
    $(e.currentTarget).parent().find('.btn-edit').attr('style', '')

    $(e.currentTarget).parent().find('.btn-save').hide()
    $(e.currentTarget).parent().find('.btn-cancel').hide()
    $(e.currentTarget).parent().addClass('hoverable')
    $(e.currentTarget).parent().find('.contact-display-container').show()
    $(e.currentTarget).parent().find('.contact-form').hide()

  delete: (e) ->
    index = $(e.currentTarget).parent().parent().attr('id')
    model = @collection.at(index)

    model.destroy
      wait: true
      success: (model, response) =>
        $(e.currentTarget).parent().parent().parent().remove();
        notify "success", "Contact deleted"
      error: (model, response) ->
        notify "error", "Contact could not be deleted"

