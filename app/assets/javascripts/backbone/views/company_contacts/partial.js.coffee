CPP.Views.Contacts ||= {}

class CPP.Views.Contacts.Partial extends CPP.Views.Base
  template: JST['backbone/templates/company_contacts/contacts']

  events:
    'click #btn-all' : 'viewAll'

  # Company contacts view partial
  initialize: (options) ->
    @company_id = options.company_id
    if options.company
      @company = options.company
      @partial = true
      @company.company_contacts.fetch
        data: $.param({ limit: options.limit })
        success: =>
          @collection = options.company.company_contacts
          @render()
    else
      @partial = false
      @render()

  # Render the company contacts
  render: ->
    $(@el).html(@template(contacts: @collection, partial: @partial))

  # Navigate to view all contacts
  viewAll: ->
    if @collection.at(0)
      Backbone.history.navigate('/companies/' + @company_id + '/company_contacts', trigger: true)
