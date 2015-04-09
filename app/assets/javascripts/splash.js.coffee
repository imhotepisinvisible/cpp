checkY = (height) ->
  if $(window).scrollTop() > height-60
  	$('.navbar-inner').show()
  else
   	$('.navbar-inner').hide()
  return

$(window).scroll ->
  height = $(window).height();
  checkY(height)
  setSplashHeight(height)
  setSplashContainerPos(height)
  return

# Do this on load just in case the user starts half way down the page
height = $(window).height
checkY(height)
$('.navbar-inner').hide()

setSplashHeight = (height) ->
  $('#splash-header').css('height',height)

setSplashContainerPos = (height) ->
  pos = (height-260)/2
  $('#splash-header-container').css('margin-top',pos)