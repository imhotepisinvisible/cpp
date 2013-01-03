window.getOrdinal = (n) ->
   s = ["th", "st", "nd", "rd"]
   v = n % 100
   n + (s[(v - 20) % 10] || s[v] || s[0])


window.notify = (alert_class, message, time = 2000) ->
  return unless message
  n = $("#notifications")
  n.hide()
  n.removeClass()
  n.addClass("alert alert-" + alert_class)

  if window.notificationAnimation
    window.notificationAnimation.stop()

  n.html(message)
  window.notificationAnimation = n.slideDown().delay(time).slideUp()

window.tiny_mce_init = ->
  tinyMCE.init
    mode: "textareas"
    theme: "advanced"
    theme_advanced_toolbar_location: "top"
    theme_advanced_toolbar_align: "left"
    theme_advanced_statusbar_location: "none"
    # http://www.tinymce.com/wiki.php/Buttons/controls shows all available buttons
    theme_advanced_buttons1: "bold,italic,underline,|,fontselect,fontsizeselect,forecolor,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,link,unlink,image,code"
    theme_advanced_buttons2: ""
    theme_advanced_buttons3: ""

window.tiny_mce_save = ->
  tinyMCE.triggerSave true, true

# displayFunction must take one argument - the value in the model and
# must output a string to display in the edit window
window.inPlaceStopEdit = (_model, prefix, attribute, defaultValue, displayFunction) ->
    originalValue = _model.get attribute
    value = $('#' + prefix + '-' + attribute + '-editor').val()
    $('#' + prefix + '-' + attribute + '-input-container').hide()
    if value != _model.get attribute
      _model.save( attribute, value, {
          wait: true
          success: (model, response) =>
            notify "success", "Updated profile"
            display = displayFunction(model.get(attribute))
            if display
              $('#' + prefix + '-' + attribute).html display
              $('#' + prefix + '-' + attribute).removeClass('missing')
            else
              $('#' + prefix + '-' + attribute).html defaultValue
              $('#' + prefix + '-' + attribute).addClass('missing')
          error: (model, response) =>
            if response.responseText
              errorlist = JSON.parse response.responseText
              msg = ''
              for k,v of errorlist.errors
              	msg += "#{k} - #{v}\n"
            else
              msg = "Error"
            notify "error", msg
            $('#' + prefix + '-' + attribute).html displayFunction(originalValue)
        })

    $('#' + prefix + '-' + attribute + '-container').show()

window.inPlaceEdit = (_model, prefix, attribute) ->
    $('#' + prefix + '-' + attribute + '-container').hide()
    $('#' + prefix + '-' + attribute + '-editor').html(_model.get attribute)
    $('#' + prefix + '-' + attribute + '-input-container').show()
    $('#' + prefix + '-' + attribute + '-editor').focus()

window.displayErrorMessages = (errors) ->
  messages = []
  for attr, errors of errors
    messages.push errors.join(',')
  notify('error', messages.join('<br/>'))

window.displayJQXHRErrors = (data) ->
  response = JSON.parse data.jqXHR.responseText
  if response.errors
    window.displayErrorMessages(response.errors)
  else
    notify('error', "Error")

window.addTooltip = (showTooltip, message, position) ->
  if showTooltip then "rel='tooltip' title='#{message}' data-placement='#{position}'" else ''

window.loggedIn = ->
  CPP.CurrentUser? && CPP.CurrentUser isnt {}

window.isStudent = ->
  loggedIn() && CPP.CurrentUser.get('type') == "Student"

window.isCompanyAdmin = ->
  loggedIn() && CPP.CurrentUser.get('type') == "CompanyAdministrator"

window.isDepartmentAdmin = ->
  loggedIn() && CPP.CurrentUser.get('type') == "DepartmentAdministrator"

window.isAdmin = ->
  isCompanyAdmin() || isDepartmentAdmin()

# Pre: assumes you already know you're an admin
window.getAdminDepartment = ->
  CPP.CurrentUser.attributes.department_id

window.userId = ->
  CPP.CurrentUser.id