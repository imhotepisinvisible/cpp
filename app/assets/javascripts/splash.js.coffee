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
  $('#splash-login-box').css('margin-top',height-150)

$(window).scroll ->
  height = $(window).height();
  checkY(height)

$(window).resize ->
  height = $(window).height();
  checkY(height)
  setSplashHeight(height)
  setSplashContainerPos(height)
  setSplashLogin(height)

$(document).ready ->
  $('.navbar-inner').hide()
  height = $(window).height();
  setSplashLogin(height)
  setSplashHeight(height)
  setSplashContainerPos(height)
