#= require bootstrap-datepicker
# Date editor
class Backbone.Form.editors.Datepicker extends Backbone.Form.editors.Base
  tagName: 'input'
  attributes:
    type: "text"

  # Bind events
  events:
    'change' : ->
      @trigger 'change', @
    'changeDate' : ->
      @trigger 'change', @
    'focus' : ->
      @trigger 'focus', @
    'blur' : ->
      @trigger 'blur', @

  # Set up datepicker element
  # Hide after change
  initialize: (options) =>
    super(options)

    @$el.datepicker
      format: getDatePickerFormat() #"dd/mm/yyyy"
      weekStart: 1
      if @value
        @setValue(@value)
        
    @$el.datepicker().on 'changeDate', =>
      @$el.datepicker("hide")
    @setValue(@value)

  # Backbone form interface
  # Get date
  getValue: =>
    moment(@$el.val(), getDateFormat()).toDate()

  # Set date
  setValue: (date) =>
    if date == null || date.toString() == (new Date(null)).toString()
      @$el.val("")
    else
      @$el.val(moment(date).format(getDateFormat()))

  # Render
  render: =>
    @

  # Focus on date input
  focus: =>
    if (this.hasFocus)
      @$el.focus()

  # Blur date input
  blur: =>
    if (!this.hasFocus)
      @$el.blur()
