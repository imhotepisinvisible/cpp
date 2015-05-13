CPP.Views.Site ||= {}

# Site index page
class CPP.Views.Site.Index extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/site/index']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click #sp-btn-2' : 'showNav'

  # From initialise call render of the index
  initialize: ->
    @render()
    _.bindAll this, 'scroller'
    $(window).scroll @scroller
    $(window).on "resize", @resize

  # Render the index page from the template
  render: ->
    $(@el).html(@template(student: @model))
    $('.navbar-inner').hide()
    @resize()
    super
    @

  resize: ->
    height = $(window).height();
    $('#fluffer').css('height',height-60)
    setSplashContainerPos(height)
    setSplashLogin(height)
    setSplashHeight(height)

  scroller: ->
    height = $(window).height();
    if $(window).scrollTop() > height-60
    	$('.navbar-inner').show()
    else
     	$('.navbar-inner').hide()
    return

  showNav: ->
    $('.navbar-inner').show()

  setSplashHeight = (height) ->
    $('#splash-header').css('height',height+60)

  setSplashContainerPos = (height) ->
    pos = (height-260)/2
    $('#splash-header-container').css('margin-top',pos)

  setSplashLogin = (height) ->
    $('#splash-login-box').css('margin-top',height-200)
