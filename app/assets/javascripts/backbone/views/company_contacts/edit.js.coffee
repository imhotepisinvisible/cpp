CPP.Views.Contacts ||= {}

class CPP.Views.Contacts.PartialEdit extends CPP.Views.Base
  template: JST['backbone/templates/company_contacts/contacts_edit']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-all' : 'editAll'
    'click #btn-new' : 'new'
    'click #btn-save-new' : 'saveNew'
    'click #btn-cancel-new' : 'cancelNew'
    'update-sort' : 'updateSort'

  # Company contact edit page
  initialize: (options) ->
    @company_id = options.company_id
    if options.company
      # Fetch company contacts for specified company
      @limit = options.limit
      @company = options.company
      @partial = true
      @company.company_contacts.fetch
        data: $.param({ limit: @limit })
        success: =>
          @collection = options.company.company_contacts
          @initializeNoFetch()
          @collection.bind 'destroy', @reRender, @
    else
      @partial = false
      @initializeNoFetch()
      @collection.bind 'destroy', @reRender, @

  # Initialise the edit view without fetching contacts
  initializeNoFetch: ->
    @render()

    # Allow drag and droppable contacts in edit partial
    $('#contacts').sortable
      axis: "y"
      dropOnEmpty: false
      handle: '.item'
      cursor: 'crosshair'
      items: 'li'
      opacity: 1
      scroll: true
      stop: (event, ui) ->
        ui.item.trigger('drop', ui.item.index());

  # Render company contacts edit page
  render: ->
    $(@el).html(@template(contacts: @collection, partial: @partial))
    if @collection.length > 0
      @collection.each (contact) =>
        view = new CPP.Views.CompanyContact
          model: contact
          editable: @editable
        @$('#contacts').append(view.render().el)
    else
      @$('#contacts').append "No contacts right now!"
    super(true)
    @


  # Re-render company contact edit partial
  reRender: (options) ->
    if @company
      @undelegateEvents()
      new CPP.Views.Contacts.PartialEdit
        el: @el
        company: @company
        company_id: @company_id
        limit: @limit
    else
      if options.model
        @collection.push(options.model)
      @initializeNoFetch()

  # Navigate to page to view all companies
  editAll: ->
    Backbone.history.navigate('/companies/' + @company_id + '/company_contacts/edit', trigger: true)

  # Show new contact form
  new: (e) ->
    $(@el).find('#btn-cancel-new').show()
    $(@el).find('#btn-save-new').show()

    contact = new CPP.Models.CompanyContact
    contact.set 'company_id', @company_id

    @formNew = new Backbone.Form(model: contact, template: 'standardForm').render()
    Backbone.Validation.bind @formNew
    $(@el).find('#contact-list-container').html(@formNew.el)
    @formNew.on "change", =>
      @formNew.validate()

  # Save the new contact
  saveNew: (e) ->
    if @formNew.validate() == null
      @formNew.commit()
      @formNew.model.save {},
        wait: true
        forceUpdate: true
        success: (model) =>
          notify 'success', 'Contact added'
          @reRender(model: model)
        error:
          notify 'error', 'Unable to add new contact'

  # Cancel creation of new contact
  cancelNew: (e) ->
    @reRender({})

  # Resort the collection of contacts
  updateSort: (event, model, pos) ->
    @collection.remove model
    @collection.each (model, index) ->
      position = index
      position += 1  if index >= pos
      model.set "position", position

    model.set "position", pos

    @collection.add model,
      at: pos

    @collection.each (model) ->
      model.save()

    @initializeNoFetch()
