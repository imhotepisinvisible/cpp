class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['backbone/templates/companies/tile']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-tile' : 'viewCompany'
    'click #star-rating'  : 'companyHighlight'
    'click #ban-rating'   : 'companyHighlight'

  initialize: (options) ->
    # Stop propagation of change of model to colleciton
    #@model.off()
    if options.big
      @template = JST['backbone/templates/companies/top_tile']
    @render()

  render: ->
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))

  viewCompany: (e) ->
    Backbone.history.navigate('companies/' + @model.id, trigger: true)

  companyHighlight: (e) ->
    ct = $(e.currentTarget)
    e.stopPropagation()
    # Set rating
    if (ct.hasClass('icon-star-empty'))
      rating = 1
    else if (ct.hasClass('icon-ban-circle') && !ct.hasClass('red-ban'))
      rating = 3
    else
      rating = 2
    @model.set("rating", rating)
    $.post "companies/#{@model.id}/set_rating",
      {rating: rating}
