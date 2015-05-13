checkY = (height) ->
  if $(window).scrollTop() > height-60
  	$('.navbar-inner').show()
  else
   	$('.navbar-inner').hide()
  return

setSplashHeight = (height) ->
  $('#splash-header').css('height',height)

setSplashContainerPos = (height) ->
  pos = (height-260)/2
  $('#splash-header-container').css('margin-top',pos)

setSplashLogin = (height) ->
  $('#splash-login-box').css('margin-top',height-200)

setSpanCardHeight = ->
  height1 = $('#span-text-1').height();
  height2 = $('#span-text-2').height();
  height3 = $('#span-text-3').height();

  heights = [height1,height2,height3]

  max = Math.max.apply(Math, heights)

  if max > 220
    $('#span-card').css('height', max+80)
  else
    $('#span-card').css('height', 300)

###

$(window).scroll ->
  height = $(window).height();
  checkY(height)

$(window).resize ->
  height = $(window).height();
  checkY(height)
  setSplashHeight(height)
  setSplashContainerPos(height)
  setSplashLogin(height)
  setSpanCardHeight()

$(document).ready ->
  $('.navbar-inner').hide()
  height = $(window).height();
  setSplashContainerPos(height)
  setSplashLogin(height)
  setSplashHeight(height)
  setSpanCardHeight()
  ###
