CPP.Views.Students ||= {}
# Student view
class CPP.Views.Students.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/students/index']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .button-export-cvs'      : 'exportCVs'
    "click .button-student-suspend" : "suspend"
    'click .button-delete-students' : 'deleteSelected'
    'click #students-table tbody tr': 'viewStudent'

  # Bind to update placement collection
  initialize: ->
    @collection.on "fetch", (->
    	@$('#students-table').append "<div class=\"loading\"></div>"
    	return), @
    @collection.bind 'reset', (->
    	@$('.loading').remove()
    	return), @
    @editable = isDepartmentAdmin()
    @render()

  # Render index template, students and filters
  render: ->
    company_columns = [
      {
        name: ''
        cell: 'select-row'
        headerCell: 'select-all'
      }
      {
        name: 'first_name'
        label: 'First Name'
        editable: false
        cell: 'string'
        sortValue: (model, sortKey) ->
          return model.get('first_name').toLowerCase()
      }
      {
        name: 'last_name'
        label: 'Last name'
        cell: 'string'
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('last_name').toLowerCase()
      }
      {
        name: 'year'
        label: 'Graduating'
        cell: 'string'
        editable: false
      }
      {
        name: 'course_name'
        label: 'Course'
        cell: 'string'
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('course_name').toLowerCase()
      }
      {
        name: 'updated_at'
        label: 'Last Updated'
        cell: Backgrid.Cell.extend(render: ->
          updated = moment(@model.get('updated_at')).fromNow()
          @$el.text updated
          @
        )
        editable: false
        sortValue: (model, sortKey) ->
          return model.get('updated_at')
      }]
    hidden_columns = [
      {
        name: 'is_active'
        label: 'Active'
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('is_active')
            result = "<i class=\"icon-ok\" />"
          else
            result = "<i class=\"icon-remove\" />"
          @$el.html result
          @
        )
        editable: false
      }
      {
        name: 'confirmed'
        label: 'Confirmed'
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('confirmed')
            result = "<i class=\"icon-ok\" />"
          else
            result = "<i class=\"icon-remove\" />"
          @$el.html result
          @
        )
        editable: false
      }
      {
        name: 'cid'
        label: 'College ID'
        cell: 'string'
        editable: false
      }
      {
        cell: EditCell
      }
      {
        cell: DeleteCell
      }]
    admin_columns = _.union(company_columns,hidden_columns)

    $(@el).html(@template(students: @collection, editable: @editable))

    if isDepartmentAdmin()
      @studentGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: admin_columns
        collection: @collection)
    else
      @studentGrid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: company_columns
        collection: @collection)

    # Render the grid and attach the root to your HTML document
    $table = $('#students-table')
    $table.append @studentGrid.render().el

    # Initialize the paginator
    paginator = new (Backgrid.Extension.Paginator)(collection: @collection)
    # Render the paginator
    $table.after paginator.render().el

    # Initialize a client-side filter to filter on the client
    # mode pageable collection's cache.
    filter = new (Backgrid.Extension.ClientSideFilter)(
      collection: @collection
      fields: [ 'first_name', 'last_name', 'year', 'course' ])
    # Render the filter
    $table.before filter.render().el
  @

  exportCVs: ->
    if @studentGrid.getSelectedModels().length > 0
      window.location = "export_cvs?students=" + _.pluck(@studentGrid.getSelectedModels(), "id")
    else
      notify('error', "No students selected")
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
  #  e.preventDefault()
    if @studentGrid.getSelectedModels().length > 0
      if confirm("Suspend selected Student accounts?")
        $.ajax
          url: "students/suspend"
          type: 'PUT'
          dataType : 'html'
          data:
             students: _.pluck(@studentGrid.getSelectedModels(), "id")
          success: =>
            notify 'success', "student accounts suspended"
    else
      notify('error', "No students selected")
  @

  viewStudent: (e) ->
    model = $(e.target).parent().data('model')
    Backbone.history.navigate("students/" + model.id, trigger: true)

  deleteSelected: ->
    if @studentGrid.getSelectedModels().length > 0
      if confirm("Are you sure you want to delete the selected students?")
        _.each(@studentGrid.getSelectedModels(), @destroy)
    else
      notify "error", "No students selected"

  destroy: (student) ->
      @success = true
      student.destroy
        wait: true
        success: (model, response) ->
          notify "success", "Student deleted"
        error: (model, response) ->
          notify "error", "Student could not be deleted"
