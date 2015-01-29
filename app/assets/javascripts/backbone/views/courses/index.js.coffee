CPP.Views.Course ||= {}

class CPP.Views.Course extends CPP.Views.Base
  el: "#app"
  template: JST['backbone/template/courses/course']

  # events: -> _.extend {}, CPP.Views.Base::events,
  #   'click .btn-edit'       : 'edit'
  #   'click .btn-view'       : 'view'
  #   'click .btn-delete'     : 'delete'
  #   'click .btn-new_course' : 'edit' #check double barrel

  initialize: (options) ->
    @render

  render: ->
    $(@el).html(@template(courses: @collection))
    @renderCourses(@collection)

  renderCourses: (col) ->
    @$('#courses').html("")
    col.each (course) =>
      view = new CPP.Views.Courses.Item(model: course)
      @$('#courses').append(view.render().el)
    @
