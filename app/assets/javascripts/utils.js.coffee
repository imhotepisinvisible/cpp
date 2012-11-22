window.getOrdinal = (n) ->
   s = ["th", "st", "nd", "rd"]
   v = n % 100
   n + (s[(v - 20) % 10] || s[v] || s[0])

# displayFunction must take one argument - the value in the model and
# must output a string to display in the edit window
window.inPlaceStopEdit = (_model, prefix, attribute, defaultValue, displayFunction) ->
    originalValue = _model.get attribute
    value = $('#' + prefix + '-' + attribute + '-editor').val()
    $('#' + prefix + '-' + attribute + '-input-container').hide()

    if value != _model.get attribute
      _model.set attribute, value
      _model.save {},
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
            errorlist = JSON.parse response.responseText
            msg = ''
            for k,v of errorlist.errors
            	msg += "#{k} - #{v}\n"
            notify "error", msg
            $('#' + prefix + '-' + attribute).html displayFunction(originalValue)

    $('#' + prefix + '-' + attribute + '-container').show()

window.inPlaceEdit = (_model, prefix, attribute) ->
    $('#' + prefix + '-' + attribute + '-container').hide()
    $('#' + prefix + '-' + attribute + '-editor').html(_model.get attribute)
    $('#' + prefix + '-' + attribute + '-input-container').show()
    $('#' + prefix + '-' + attribute + '-editor').focus()