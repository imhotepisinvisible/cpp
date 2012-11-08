class CPP.Views.EmailsPartialItem extends CPP.Views.Base
  tagName: "li"
  className: "email-item"

  events:
    'click .btn-edit' : 'editEmail'
    'click'           : 'viewEmail'

  template: JST['emails/partial_item']

  render: (options) ->
    $(@el).html(@template(email: @model, editable: options.editable))
    @

  editEmail: (e) ->
    e.stopPropagation()
    Backbone.history.navigate('emails/' + @model.id + '/edit', trigger: true)

  viewEmail: ->
    Backbone.history.navigate('emails/' + @model.id, trigger: true)
