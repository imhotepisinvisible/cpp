class CPP.Views.CompaniesView extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/companies/view']

  events: -> _.extend {}, CPP.Views.Base::events,
    'click #star-rating'  : 'companyHighlight'
    'click #ban-rating'   : 'companyHighlight'

  initialize: ->
    if isStudent()
      @model.record_stat_view()
    @render()

  render: ->
    $(@el).html(@template(company: @model, tooltip: (loggedIn() and CPP.CurrentUser.get('tooltip'))))

    super

    events_partial = new CPP.Views.Events.Partial
      el: $(@el).find('#events-partial')
      company: @model
      collection: @model.events

    placements_partial = new CPP.Views.Placements.Partial
      el: $(@el).find('#placements-partial')
      company: @model
      collection: @model.placements

    contacts_partial = new CPP.Views.Contacts.Partial
      el: $(@el).find('#contacts-partial')
      company: @model
      company_id: @model.id
      limit: 3

    if isAdmin()
      emails_partial = new CPP.Views.Emails.Partial
        el: $(@el).find('#emails-partial')
        company: @model
        collection: @model.emails

      new CPP.Views.Companies.StatsPartial
        company: @model

    @

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
      {rating: rating},
      =>
        $('#ban-rating').removeClass('red-ban icon-ban-circle')
        $('#ban-rating').addClass(@model.getBanClass())
        $('#star-rating').removeClass('golden-star icon-star icon-star-empty')
        $('#star-rating').addClass(@model.getStarClass())


