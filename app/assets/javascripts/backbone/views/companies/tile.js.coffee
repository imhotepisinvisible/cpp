# Company tile with image and description
class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['backbone/templates/companies/tile']
  # Bind events
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-tile' : 'viewCompany'
    'click #star-rating'  : 'companyHighlight'
    'click #ban-rating'   : 'companyHighlight'

  # set template for top tile (larger view) 
  initialize: (options) ->
    if options.big
      @template = JST['backbone/templates/companies/top_tile']
    @render()

  # Render company tile 
  render: ->
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))

  # Navigate to the company view
  viewCompany: (e) ->
    Backbone.history.navigate('companies/' + @model.id, trigger: true)

  # Stop click propagating to company
  # Set company rating, 1 is favourite, 2 is neutral and 3 is to ban a company
  companyHighlight: (e) ->
    ratingIcon = $(e.currentTarget)
    e.stopPropagation()
    if (ratingIcon.hasClass('icon-star-empty'))
      rating = 1
    else if (ratingIcon.hasClass('icon-ban-circle') && !ratingIcon.hasClass('red-ban'))
      rating = 3
    else
      rating = 2
    @model.set("rating", rating)
    $.post "companies/#{@model.id}/set_rating",
      {rating: rating}
