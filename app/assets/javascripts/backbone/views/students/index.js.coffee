CPP.Views.Students ||= {}
# Student view
class CPP.Views.Students.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/students/index']

  # Bind to update placement collection
  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderStudents, @
    @editable = isDepartmentAdmin()
    @render()

  # Render index template, students and filters
  render: ->
    $(@el).html(@template(students: @collection, editable: @editable))
    @renderStudents(@collection)
    @renderFilters()
  @

  # Remove all student then for each student
  # in the collection passed in, render the student
  renderStudents: (col) ->
    @$('#students').html("")
    col.each (student) =>
      view = new CPP.Views.Students.Item(model: student, editable: @editable)
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
        {name: "Year"
        type: "number"
        attribute: 'year'
        scope: ''},
        {name: "Degree",
        type: 'text',
        attribute: 'degree',
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
  @
