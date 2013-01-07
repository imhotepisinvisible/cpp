class CPP.Views.Base extends Backbone.View
  events:
    'click .back': 'back'

  render: (noUnbind) ->
    super
    unless noUnbind
      $(@el).unbind()

    $("a[rel=popover]").popover()
    $(".tooltip").tooltip()
    $("[rel=tooltip]").tooltip()
    @

  back: ->
    window.history.back()
