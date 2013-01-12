class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['backbone/templates/companies/tile']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-tile' : 'viewCompany'
    'click #star-rating'  : 'companyHighlight'
    'click #ban-rating'   : 'companyHighlight'

  initialize: (options) ->
    if options.big
      @template = JST['backbone/templates/companies/top_tile']
    @render()

  render: ->
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))

  viewCompany: (e) ->
    Backbone.history.navigate('companies/' + @model.id, trigger: true)

  companyHighlight: (e) ->
    ratingIcon = $(e.currentTarget)
    # Stop click propagating to company
    e.stopPropagation()
    # Set company rating 1 is favourite
    if (ratingIcon.hasClass('icon-star-empty'))
      rating = 1
    else if (ratingIcon.hasClass('icon-ban-circle') && !ratingIcon.hasClass('red-ban'))
      # Rating 3 is ban company
      rating = 3
    else
      # Rating 2 is neutral
      rating = 2
    @model.set("rating", rating)
    $.post "companies/#{@model.id}/set_rating",
      {rating: rating}
