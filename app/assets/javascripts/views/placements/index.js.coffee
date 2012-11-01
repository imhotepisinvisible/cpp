class CPP.Views.PlacementsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['placements/index']

  events:
    "click .btn-add"      : "addPlacement"
    'click .company-logo-header' : 'viewCompany'

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @
    # bind to model destroy so backbone view updates on destroy
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template(placements: @collection))

    @collection.each (placement) =>
      placement.company = new CPP.Models.Company id: placement.get("company_id")
      placement.company.fetch
        success: ->
          # Render the placement if we can get its company
          view = new CPP.Views.PlacementsItem model: placement
          @$('#placements').append(view.render().el)
        error: ->
          notify "error", "Couldn't fetch company for placement"
    @

  addPlacement: ->
    Backbone.history.navigate("companies/" + @collection.company.id + "/placements/new", trigger: true)

  viewCompany: ->
    if @collection.company 
      Backbone.history.navigate("companies/" + @collection.company.id, trigger: true)
    
