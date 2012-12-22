class CPP.Views.StudentsItem extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/students/item']

  initialize: ->
    #@render()

  events: -> _.extend {}, CPP.Views.Base::events,
    "click" : "viewStudent"


  render: ->
    $(@el).html(@template(student: @model))
    @

  viewStudent: ->
    Backbone.history.navigate("students/" + @model.get('id'), trigger: true)
