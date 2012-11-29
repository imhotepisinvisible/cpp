class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['companies/tile']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-tile' : 'viewCompany'
    'click #star-rating'  : 'companyHighlight'
    'click #ban-rating'   : 'companyHighlight'  

  initialize: (options) ->
    # Stop propagation of change of model to colleciton
    @model.off()
    if options.big
      @template = JST['companies/top_tile']
    @render()

  render: ->
    $(@el).html(@template(company: @model))

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
      console.log "star"
      rating = 2
    @model.set("rating", rating)
    console.log @model.get "rating"
    $.post "companies/#{@model.id}/set_rating",
      {rating: rating},
      (data) =>
        # Update icon
        console.log ct.siblings()
        if rating == 1
          if (ct.hasClass('icon-star-empty'))
            ct.addClass('golden-star icon-star')
            ct.removeClass('icon-star-empty')
            ct.prev().removeClass('red-ban')
          if (ct.hasClass('icon-ban-circle'))
            ct.addClass('red-ban')
        else if rating == 3
          if (ct.hasClass('icon-ban-circle'))
            ct.addClass('red-ban')
            ct.next().removeClass('golden-star icon-star')
            ct.next().addClass('icon-star-empty')
        else
          if (ct.hasClass('icon-star'))
            ct.addClass('icon-star-empty')
            ct.removeClass('golden-star icon-star')
          if (ct.hasClass('icon-ban-circle'))
            ct.removeClass('red-ban')
