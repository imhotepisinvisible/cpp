# Calculates ordinal for number
# 
window.getOrdinal = (n) ->
   s = ["th", "st", "nd", "rd"]
   v = n % 100
   n + (s[(v - 20) % 10] || s[v] || s[0])

# Drops down notify bar on the client screen
# Red if alert_class is error
# Green if alert_class is success
# Displays message on bar
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

# Sets up email editor
# http://www.tinymce.com/wiki.php/Buttons/controls shows all available buttons
window.tiny_mce_init = ->
  tinyMCE.init
    mode: "textareas"
    theme: "advanced"
    theme_advanced_toolbar_location: "top"
    theme_advanced_toolbar_align: "left"
    theme_advanced_statusbar_location: "none"
    theme_advanced_buttons1: "bold,italic,underline,|,fontselect,fontsizeselect,forecolor,|,justifyleft,justifycenter,justifyright,justifyfull,|,bullist,numlist,|,link,unlink,image,code"
    theme_advanced_buttons2: ""
    theme_advanced_buttons3: ""

# Store contents of editor into input variable
window.tiny_mce_save = ->
  tinyMCE.triggerSave true, true

# Stops editing in place and saves model
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

# Hides container and shows field editor
window.inPlaceEdit = (_model, prefix, attribute) ->
    $('#' + prefix + '-' + attribute + '-container').hide()
    $('#' + prefix + '-' + attribute + '-editor').html(_model.get attribute)
    $('#' + prefix + '-' + attribute + '-input-container').show()
    $('#' + prefix + '-' + attribute + '-editor').focus()

# Joins messages of errors into a string then notifies user
window.displayErrorMessages = (errors) ->
  messages = []
  for attr, errors of errors
    messages.push errors.join(',')
  notify('error', messages.join('<br/>'))

# Parses JQXHR errors and displays to user
window.displayJQXHRErrors = (data) ->
  response = JSON.parse data.jqXHR.responseText
  if response.errors
    window.displayErrorMessages(response.errors)
  else
    notify('error', "Error")

# Shows tooltip with specified message and position to user
window.addTooltip = (showTooltip, message, position) ->
  if showTooltip then "rel='tooltip' title='#{message}' data-placement='#{position}'" else ''

# Company approval statuses for departments
window.CPP_APPROVAL_STATUS = {
  REJECTED: -1
  NOT_REQ:   0
  PENDING:   1
  APPROVED:  2
  PARTNERED: 3
}

# Returns message for approval status
window.approvalStatusMap = (code) ->
  switch code
    when CPP_APPROVAL_STATUS.REJECTED  then 'Rejected, not visible to students from this department'
    when CPP_APPROVAL_STATUS.NOT_REQ   then 'Not requested, not visible to students from this department'
    when CPP_APPROVAL_STATUS.PENDING   then 'Pending, not visible to students from this department'
    when CPP_APPROVAL_STATUS.APPROVED  then 'Approved, visible to students from this department'
    when CPP_APPROVAL_STATUS.PARTNERED then 'Partnered, can view students from this department'
    else code

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

window.getUserCompanyId = ->
  CPP.CurrentUser.attributes.company_id

window.userId = ->
  CPP.CurrentUser.id
