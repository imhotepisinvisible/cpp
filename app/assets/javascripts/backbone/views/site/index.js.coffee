CPP.Views.Site ||= {}

# Site index page
class CPP.Views.Site.Index extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/site/index']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'scroll' : 'scroller'
    'click #sp-btn-1' : 'moveNav'

  # From initialise call render of the index
  initialize: ->
    $(window).on "resize", @resize
    $(window).scroll @scroller
    @render()

  # Render the index page from the template
  render: ->
    $(@el).html(@template(student: @model))
    $('.navbar-inner').hide()
    @resize()
    super
    @

  moveNav: (e) ->
    e.preventDefault()
    $('.btn-navbar.collapsed').click()
    height = $(window).height();
    window.scrollTo 0, height-55

  resize: ->
    height = $(window).height();
    $('#fluffer').css('height',height-60)
    setSplashContainerPos(height)
    setSplashLogin(height)
    setSplashHeight(height)
    h1 = $('#t1').height()
    h2 = $('#t2').height()
    h3 = $('#t3').height()
    h = Math.max.apply(Math,[h1,h2,h3])
    $('.pic').css('height',h+40)
    console.log "show"
    $('.navbar').hide()
    $('.navbar').show()


  scroller: ->
    height = $(window).height();
    if $(window).scrollTop() > height-60
    	$('.navbar-inner').show()
    else
     	$('.navbar-inner').hide()
    return

  setSplashHeight = (height) ->
    $('#splash-header').css('height',height+60)

  setSplashContainerPos = (height) ->
    pos = (height-260)/2
    $('#splash-header-container').css('margin-top',pos)

  setSplashLogin = (height) ->
    $('#splash-login-box').css('margin-top',height-200)
