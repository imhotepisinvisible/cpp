class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['companies/tile']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-tile' : 'viewCompany'
    'click #star-rating' : 'companyHighlight'

  initialize: (options) ->
    if options.big
      @template = JST['companies/top_tile']
    @render()

  render: ->
    $(@el).html(@template(company: @model))

  viewCompany: (e) ->
    Backbone.history.navigate('companies/' + @model.id, trigger: true)

  companyHighlight: (e) ->
    e.stopPropagation()
    # Set rating
    if ($(e.currentTarget).hasClass('golden-star'))
      rating = 2
    else
      rating = 1

    $.post "companies/#{@model.id}/set_rating",
      {rating: rating},
      (data) ->
        # Update star
        if rating != 1
          $(e.currentTarget).removeClass('golden-star icon-star')
          $(e.currentTarget).addClass('icon-star-empty')
        else
          $(e.currentTarget).addClass('golden-star icon-star')
          $(e.currentTarget).removeClass('icon-star-empty')