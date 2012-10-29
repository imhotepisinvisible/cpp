#= require bootstrap-datepicker

class Backbone.Form.editors.Datepicker extends Backbone.Form.editors.Base
  tagName: 'div'
  attributes:
    type: "text"

  events:
    "change" : -> 
      @trigger "change", @

  initialize: (options) =>
    super(options)
    # Set up datepicker element
    @$dp = $("<input type='text'/>")
    @$dp.datepicker
      format: "dd/mm/yyyy"
      weekStart: 1

    # Set up time pickers
    @$hp = $("<input type='text' class='input-small' placeholder='hour'/>")
    @$mp = $("<input type='text' class='input-small' placeholder='minutes'/>")

    @$el.append(@$dp)
    @$el.append(@$hp)
    @$el.append(@$mp)

    @setValue(@value)

  getValue: =>
    #[day, month, year] = @$dp.val().split "/"
    #month -= 1 # JavaScript months index from 0
    hours = @$hp.val() || "00"
    mins = @$mp.val() || "00"
    # d = new Date(year, month, day, hours, mins, 0, 0)
    # console.log "DATETIME: ", d
    # console.log d.toISOString()
    console.log @$dp.val() + " " + hours + ":" + mins
    d = Date.parse(@$dp.val() + " " + hours + ":" + mins)
    console.log "d", d
    console.log "dstring", d.toISOString()
  
  setValue: (value) =>
    d = Date.parse(value)
    #set @$dp.val(d.)

  render: =>
    @