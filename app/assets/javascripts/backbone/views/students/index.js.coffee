CPP.Views.Students ||= {}
# Student view
class CPP.Views.Students.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/students/index']

  events:
    "click .button-student-suspend": "suspend"

  # Bind to update placement collection
  initialize: ->
    @collection.on "fetch", (->
        @$('#students-table').html "<div class=\"loading\"></div>"
        return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderStudents, @
    @editable = isDepartmentAdmin()
    @courses = new CPP.Collections.Courses
    @courses.fetch({async:false})
    @render()

  # Render index template, students and filters
  render: ->
    $(@el).html(@template(students: @collection, editable: @editable))
    @renderStudents(@collection)
    @renderFilters()
  @

  # Remove all students, then for each student
  # in the collection passed in, render the student
  renderStudents: (col) ->
    @$('#students').html("")
    col.each (student) =>
      view = new CPP.Views.Students.Item(model: student, editable: @editable, courses: @courses)
      @$('#students').append(view.render().el)
  @

  # Define the filters to render
  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#student-filter')
      filters: [
        {name: "Tags"
        type: 'tags'
        attribute: ["skill_list", "interest_list", "year_group_list"]
        scope: ''},
        {name: "Graduating in"
        type: "text"
        attribute: 'year'
        scope: ''},
        {name: "Graduating after"
        type: "graduating-after"
        attribute: 'year'
        scope: ''},
        {name: "Course",
        type: 'course',
        attribute: 'course_id',
        scope: ''},
        {name: "First Name"
        type: "text"
        attribute: "first_name"
        scope: ""},
        {name: "Last Name"
        type: "text"
        attribute: "last_name"
        scope: ""}
      ]
      data: @collection
      courses: @courses
  @

  work: -> 
    students = new CPP.Collections.Students
    students.fetch
      success: (students) ->
        students.each (student) ->
          student.set("active", false)
          student.save {},
            wait: true
            forceUpdate: true
            success: (student, response) ->
              console.log(first_name + "updated")
            error: (student, response) ->
              console.log(first_name + "not updated")

  suspend: (e) -> 
    #e.stopPropagation()
    e.preventDefault()
    if confirm("Suspend all Student accounts?")
      $.ajax
        url: "students/suspend"
        type: 'PUT'
        data: 
          students: @collection.pluck('id')
        success: =>
          notify 'success', "All student accounts suspended" 
  @


                