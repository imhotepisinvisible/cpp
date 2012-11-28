class CPP.Views.CompanyTile extends CPP.Views.Base
  template: JST['companies/tile']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click .company-tile' : 'viewCompany'
    'click #company-highlight' : 'companyHighlight'

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
    coStar = $(e.currentTarget)
    if (coStar.hasClass('goldenStar'))
      $(e.currentTarget).html("&#9734")
      $(e.currentTarget).removeClass('goldenStar')
    else 
      $(e.currentTarget).html("&#9733")
      $(e.currentTarget).addClass('goldenStar')