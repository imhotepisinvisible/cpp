CPP.Views.Courses ||= {}

class CPP.Views.Courses.Index extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/templates/courses/index']

  events: -> _.extend {}, CPP.Views.Base::events,
      'click .btn-new_course' : 'new' 

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @collection.bind 'change', @render, @    
    @collection.bind 'destroy', @render, @
    @render()

  render: ->
    $(@el).html(@template(courses: @collection))
    @renderCourses(@collection)
  @

  renderCourses: (col) ->
    @$('#courses').html("")
    col.each (course) =>
      view = new CPP.Views.Courses.Item(model: course)
      @$('#courses').append(view.render().el)
    @
  new: ->
    Backbone.history.navigate("companies/new" , trigger: true)
