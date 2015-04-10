checkY = (height) ->
  console.log "check"
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

$(window).scroll ->
  height = $(window).height();
  checkY(height)

$(window).resize ->
  height = $(window).height();
  checkY(height)
  setSplashHeight(height)
  setSplashContainerPos(height)

$(document).ready ->
  $('.navbar-inner').hide()
  height = $(window).height();
  setSplashHeight(height)
  setSplashContainerPos(height)
