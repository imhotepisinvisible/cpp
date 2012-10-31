#= require bootstrap-datepicker

class Backbone.Form.editors.Datepicker extends Backbone.Form.editors.Base
  tagName: 'input'
  attributes:
    type: "text"

  events:
    'change' : -> 
      @trigger 'change', @
    'changeDate' : ->
      @trigger 'change', @
    'focus' : -> 
      @trigger 'focus', @
    'blur' : -> 
      @trigger 'blur', @


  initialize: (options) =>
    super(options)

    # Set up datepicker element
    @$el.datepicker
      format: "dd/mm/yyyy"
      weekStart: 1
    # Hide after change
    @$el.datepicker().on 'changeDate', =>
      @$el.datepicker("hide")
    @setValue(@value)

  
  getValue: =>
    Date.parseExact(@$el.val(), "d/M/yyyy")

  setValue: (date) =>
    if date == null || date.toString() == (new Date(null)).toString()
      @$el.val("")
    else
      @$el.val(date.toString("d/M/yyyy"))

  render: =>
    @

  focus: =>
    if (this.hasFocus)
      @$el.focus()

  blur: =>
    if (!this.hasFocus)
      @$el.blur()
