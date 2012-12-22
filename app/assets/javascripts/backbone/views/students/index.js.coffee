class CPP.Views.StudentsIndex extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/students/index']

  initialize: ->
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderStudents, @
    @render()

  render: ->
    $(@el).html(@template(students: @collection))
    @renderStudents(@collection)
    @renderFilters()
  @

  renderStudents: (col) ->
    @$('#students').html("")
    col.each (student) ->
      view = new CPP.Views.StudentsItem model: student
      @$('#students').append(view.render().el)
  @

  renderFilters: ->
    new CPP.Filter
      el: $(@el).find('#student-filter')
      filters: [
        {name: "First Name Search"
        type: "text"
        attribute: "first_name"
        scope: ""},
        {name: "Last Name Search"
        type: "text"
        attribute: "last_name"
        scope: ""},
      ]
      data: @collection
  @
