class CPP.Views.ContactsPartialEdit extends CPP.Views.Base
  template: JST['company_contacts/contacts_edit']

  events:
    'click .btn-edit' : 'edit'
    'click .btn-save' : 'save'
    'click .btn-delete' : 'delete'
    'click .btn-cancel' : 'cancel'
    'click #btn-all' : 'editAll'
    'click #btn-new' : 'new'
    'click #btn-save-new' : 'saveNew'
    'click #btn-cancel-new' : 'cancelNew'

  initialize: (options) ->
    @company_id = options.company_id
    if options.company
      @limit = options.limit
      @company = options.company
      @company.company_contacts.fetch
        data: $.param({ limit: @limit })
        success: =>
          @collection = options.company.company_contacts
          @initializeNoFetch()
    else
      @initializeNoFetch()

  initializeNoFetch: ->
    @render()
    @forms = []

    for contact, index in @collection.models
      @forms.push(new Backbone.Form(model: contact, template: 'standardForm').render())
      Backbone.Validation.bind @forms[index]
      $(@el).find('#' + index + '.item').find('.contact-form').html(@forms[index].el)
    
  render: ->
    $(@el).html(@template(contacts: @collection))

  reRender: (options) ->
    if @company
      @undelegateEvents()
      new CPP.Views.ContactsPartialEdit
        el: @el
        company: @company
        company_id: @company_id
        limit: @limit
    else
      if options.model
        @collection.unshift(options.model)
      @render()

  editAll: ->
    Backbone.history.navigate('/companies/' + @company_id + '/company_contacts/edit', trigger: true)

  edit: (e) ->
    $(e.currentTarget).parent().parent().find('.btn-container').hide()
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
    $(e.currentTarget).parent().find('.btn-container').attr('style', '')

    $(e.currentTarget).parent().find('.btn-save').hide()
    $(e.currentTarget).parent().find('.btn-cancel').hide()
    $(e.currentTarget).parent().addClass('hoverable')
    $(e.currentTarget).parent().find('.contact-display-container').show()
    $(e.currentTarget).parent().find('.contact-form').hide()

  delete: (e) ->
    index = $(e.currentTarget).parent().parent().attr('id')
    console.log index
    model = @collection.at(index)

    model.destroy
      wait: true
      success: (model, response) =>
        console.log 'success delete!!'
        @reRender({})
        notify "success", "Contact deleted"
      error: (model, response) ->
        notify "error", "Contact could not be deleted"

  new: (e) ->
    $(@el).find('#btn-cancel-new').show()
    $(@el).find('#btn-save-new').show()

    contact = new CPP.Models.CompanyContact
    contact.set 'company_id', @company_id

    @formNew = new Backbone.Form(model: contact, template: 'standardForm').render()
    Backbone.Validation.bind @formNew
    $(@el).find('#contact-list-container').html(@formNew.el)

  saveNew: (e) ->
    if @formNew.validate() == null
      @formNew.commit()
      @formNew.model.save {},
        wait: true
        success: (model) =>
          notify 'success', 'Contact added'
          @reRender(model: model)
        error:
          notify 'error', 'Unable to add new contact'

  cancelNew: (e) ->
    @reRender({})
