class CPP.Views.ContactsPartialEdit extends CPP.Views.Base
  template: JST['company_contacts/contacts_edit']
  
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #btn-all' : 'editAll'
    'click #btn-new' : 'new'
    'click #btn-save-new' : 'saveNew'
    'click #btn-cancel-new' : 'cancelNew'
    'update-sort' : 'updateSort'

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
          @collection.bind 'destroy', @reRender, @
    else
      @initializeNoFetch()
      @collection.bind 'destroy', @reRender, @


  initializeNoFetch: ->
    @render()

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
    
  render: ->
    $(@el).html(@template(contacts: @collection))
    if @collection.length > 0
      @collection.each (contact) =>
        view = new CPP.Views.CompanyContact
                      model: contact
                      editable: @editable
        @$('#contacts').append(view.render().el)
    else
      @$('#contacts').append "No contacts right now!"
    @


  reRender: (options) ->
    console.log @collection
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
      @initializeNoFetch()

  editAll: ->
    Backbone.history.navigate('/companies/' + @company_id + '/company_contacts/edit', trigger: true)

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
