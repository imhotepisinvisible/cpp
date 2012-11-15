class CPP.Views.EmailsPartialItem extends CPP.Views.Base
  tagName: "tr"
  className: "email-item"

  events:
    'click .btn-edit' : 'editEmail'
    'click'           : 'viewEmail'

  template: JST['emails/partial_item']

  initialize: (options) ->
    @editable = options.editable

  render: ->
    $(@el).html(@template(email: @model, editable: @editable))
    @

  editEmail: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('emails/' + @model.id + '/edit', trigger: true)

  viewEmail: ->
    Backbone.history.navigate('emails/' + @model.id, trigger :true)
