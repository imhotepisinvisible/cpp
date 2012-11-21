class CPP.Views.Base extends Backbone.View
  events:
    'click .back': 'back'

  render: ->
    super
    $(@el).unbind()
    @

  back: ->
    window.history.back()
