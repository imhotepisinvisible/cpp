class CPP.Views.TaggedEmailsPartial extends CPP.Views.Base
  template: JST['backbone/templates/emails/partial']

  editable: false

  events: -> _.extend {}, CPP.Views.Base::events,
    "click .btn-add"      : "addEmail"
    "click .btn-view-all" : "viewCompaniesEmails"

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @render()

  render: () ->
    $(@el).html(@template(editable: @editable))
    @collection.each (email) =>
      view = new CPP.Views.TaggedEmailsPartialItem
                  model: email
                  editable: @editable
      @$('#emails').append(view.render().el)
    @

  addEmail: ->
    Backbone.history.navigate("companies/" + @model.id + "/tagged_emails/new", trigger: true)

  viewCompaniesEmails: ->
    Backbone.history.navigate("companies/" + @model.id + "/tagged_emails", trigger: true)
