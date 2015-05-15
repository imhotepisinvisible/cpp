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
    if $(window).width() > 979
      Backbone.history.navigate("login", trigger: false)
      height = $(window).height();
      window.scrollTo 0, height-55
    else
      window.location = '/login'

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
    $('#splash-header').css('height',height)

  setSplashContainerPos = (height) ->
    pos = (height-240)/2
    $('#splash-header-box-top').css('margin-top',pos)

  setSplashLogin = (height) ->
    pos = (height-100) - ((height/2)+120)
    $('#sp-button').css('margin-top',pos)
