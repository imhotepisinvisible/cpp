CPP.Views.Events ||= {}

class CPP.Views.Events.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/events/index']

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .company-logo-header"      : "viewCompany"


  initialize: ->
    #@collection.each (model) ->
      #model.set "visible", true
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderEvents, @
    @editable = isAdmin()
    @render()

  render: ->
    lcompanies = []
    ready = $.Deferred()
    $(@el).html(@template(events: @collection, editable: @editable))
    @collection.each (event) =>
      event.company = new CPP.Models.Company id: event.get("company_id")
      event.company.fetch
        success: =>
          lcompanies.push(event.company)
          if (lcompanies.length == @collection.length)
            ready.resolve()
        error: ->
          notify "error", "Couldn't fetch company for event"
          ready.resolver()
    ready.done =>
      @renderEvents(@collection)
      @renderFilters()
  @

  renderEvents: (col) ->
    @$('#events').html("")
    col.each (event) =>
      view = new CPP.Views.Events.Item(model: event, editable: @editable)
      @$('#events').append(view.render().el)
    @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#event-filter')
      filters: [
        {name: "Tags"
        type: "tags"
        attribute: ["skill_list", "interest_list", "year_group_list"]
        scope: ''},
        {name: "Starting After",
        type: 'date',
        attribute: 'start_date'
        default: Date.today().toString('yyyy-MM-dd')
        scope: ''},
        {name: "Company"
        type: "text"
        attribute: "name"
        scope: ".company"},
        {name: "Event Title",
        type: "text",
        attribute: 'title',
        scope: ''},
        {name: "Location"
        type: "text"
        attribute: "location"
        scope: ""},
        {name: "Starting After",
        type: 'date',
        attribute: 'start_date'
        default: Date.today().toString('yyyy-MM-dd')
        scope: ''},
      ]
      data: @collection
  @

  viewCompany: ->
    if @collection.company
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
