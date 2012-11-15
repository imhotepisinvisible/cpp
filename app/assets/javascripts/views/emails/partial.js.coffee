class CPP.Views.EmailsPartial extends CPP.Views.Base
  template: JST['emails/partial']

  editable: false

  events:
    "click .btn-add"      : "addEmail"
    "click .btn-view-all" : "viewCompaniesEmails"

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @render()

  render: () ->
    $(@el).html(@template(editable: @editable))
    @collection.each (email) =>
      view = new CPP.Views.EmailsPartialItem
                  model: email
                  editable: @editable
      @$('#emails').append(view.render().el)
    @

  addEmail: ->
    Backbone.history.navigate("companies/" + @model.id + "/emails/new", trigger: true)

  viewCompaniesEmails: ->
    Backbone.history.navigate("companies/" + @model.id + "/emails", trigger: true)
