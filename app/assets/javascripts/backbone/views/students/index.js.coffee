CPP.Views.Students ||= {}

class CPP.Views.Students.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/students/index']

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderStudents, @
    @editable = isDepartmentAdmin()
    @render()

  render: ->
    $(@el).html(@template(students: @collection, editable: @editable))
    @renderStudents(@collection)
    @renderFilters()
  @

  renderStudents: (col) ->
    @$('#students').html("")
    col.each (student) =>
      view = new CPP.Views.Students.Item(model: student, editable: @editable)
      @$('#students').append(view.render().el)
  @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#student-filter')
      filters: [
        {name: "First Name"
        type: "text"
        attribute: "first_name"
        scope: ""},
        {name: "Last Name"
        type: "text"
        attribute: "last_name"
        scope: ""},
        {name: "Year"
        type: "number"
        attribute: 'year'
        scope: ''},
        {name: "Tags"
        type: 'tags'
        attribute: 'skill_list'
        scope: ''}
      ]
      data: @collection
  @
