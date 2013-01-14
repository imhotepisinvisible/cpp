# All views inherit from base view 
class CPP.Views.Base extends Backbone.View
  # Events common to all views
  events:
    'click .back': 'back'

  # Render and unbind if required then initialise tooltips
  render: (noUnbind) ->
    super
    unless noUnbind
      $(@el).unbind()

    $("a[rel=popover]").popover()
    $(".tooltip").tooltip()
    $("[rel=tooltip]").tooltip()
    @

  # Navigate to previous page
  back: ->
    window.history.back()
