class CPP.Views.Base extends Backbone.View
  render: ->
    super
    $(@el).unbind()
    @