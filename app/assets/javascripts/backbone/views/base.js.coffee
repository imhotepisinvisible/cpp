class CPP.Views.Base extends Backbone.View
  events:
    'click .back': 'back'

  render: ->
    super
    #$(@el).unbind()

    $("a[rel=popover]").popover()
    $(".tooltip").tooltip()
    $("[rel=tooltip]").tooltip()
    @

  back: ->
    window.history.back()
