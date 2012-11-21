class CPP.Views.StudentsItem extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['students/item']

  initialize: ->
    #@render()

  events: 
    "click" : "viewStudent"


  render: ->
    $(@el).html(@template(student: @model))
    @

  viewStudent: ->
    Backbone.history.navigate("students/" + @model.get('id'), trigger: true)
