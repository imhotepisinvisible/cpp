class CPP.Views.EmailsPartial extends CPP.Views.Base
  template: JST['emails/partial']

  events:
    "click .btn-add"      : "addEmail"
    "click .btn-view-all" : "viewCompaniesEmails"

  initialize: (options) ->
    @editable = options.editable
    @collection.bind 'reset', @render, @
    @render()

  render: () ->
    $(@el).html(@template(editable: @editable))
    @collection.each (email) =>
      view = new CPP.Views.EmailsPartialItem model: email
      @$('#emails').append(view.render(editable: @editable).el)
    @

  addEmail: ->
    Backbone.history.navigate("companies/" + @model.id + "/emails/new", trigger: true)

  viewCompaniesEmails: ->
    Backbone.history.navigate("companies/" + @model.id + "/emails", trigger: true)
