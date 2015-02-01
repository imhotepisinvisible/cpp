#CPP.Vies.Courses ||= {}

class CPP.Views.Courses.Item extends CPP.Views.Base
  tagName: "tr"
  className: "cpp-tbl-row"

  template: JST['backbone/templates/courses/item']

  # Individual company item in index
  #initialize: ->
    # Bind to model change so backbone view update on destroy  
   # @model.bind 'change', @render, @

  render: ->
    $(@el).html(@template(course: @model))
    @
        
