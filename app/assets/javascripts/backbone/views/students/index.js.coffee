CPP.Views.Students ||= {}
# Student view
class CPP.Views.Students.Index extends CPP.Views.Base
  el: '#app'
  template: JST['backbone/templates/students/index']

  # Bind event listeners
  events: -> _.extend {}, CPP.Views.Base::events,
    'click .button-export-cvs' : 'exportCVs'
    "click .button-student-suspend": "suspend"
    'click tr'                        : 'viewStudent'

  # Bind to update placement collection
  initialize: ->
    @collection.on "fetch", (->
        @$('#students-table').append "<div class=\"loading\"></div>"
        return), @
    @collection.bind 'reset', @render, @
    @collection.bind 'filter', @renderStudents, @
    @editable = isDepartmentAdmin()
    @courses = new CPP.Collections.Courses
    @courses.fetch({async:false})
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
        label: 'first_name'
        editable: false
        cell: 'string'
      }
      {
        name: 'last_name'
        label: 'Last name'
        cell: 'string'
        editable: false
      }
      {
        name: 'year'
        label: 'Graduating'
        cell: 'date'
        editable: false
      }
      {
        name: 'course'
        label: 'Course'
        cell: Backgrid.Cell.extend(render: ->
          course = @model.get('course_name') 
          @$el.text course
          @
        )
        editable: false
      }
      {
        name: 'updated_at'
        label: 'Last Updated'
        cell: 'date'
        editable: false
      }]
    hidden_columns = [
      {
        name: 'active'
        label: 'Active'
        cell: Backgrid.Cell.extend(render: ->
          if @model.get('active')
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
      }]     
    admin_columns = _.union(company_columns,hidden_columns)     
      
    $(@el).html(@template(students: @collection, editable: @editable))
    @renderFilters()
    
    if isDepartmentAdmin()
      grid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow      
        columns: admin_columns        
        collection: @collection)
    else
      grid = new (Backgrid.Grid)(
        className: "backgrid table-hover table-clickable",
        row: ModelRow
        columns: company_columns
        collection: @collection)    
            


    # Render the grid and attach the root to your HTML document
    $table = $('#students-table')
    $table.append grid.render().el

    # Initialize the paginator
    paginator = new (Backgrid.Extension.Paginator)(collection: @collection)
    # Render the paginator
    $table.after paginator.render().el

    # Initialize a client-side filter to filter on the client
    # mode pageable collection's cache.
    filter = new (Backgrid.Extension.ClientSideFilter)(
      collection: @collection
      fields: [ 'title' ])
    # Render the filter
    $table.before filter.render().el

    
    #@selectedModels = grid.getSelectedModels() ###########
  @

  exportCVs: ->
    #############
    console.log(@selectedModels)    
    window.location = "export_cvs?students=" + @selectedModels.pluck("id")
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
  #  e.preventDefault()
  # 
    #if @collection.length > 0
    if @selectedModels.length > 0
      if confirm("Suspend all Student accounts?")
        $.ajax
          url: "students/suspend"
          type: 'PUT'
          dataType : 'html'
          data: 
            #students: @collection.pluck('id') @selectedModels
             students: @selectedModels.pluck('id') 
          success: =>
            notify 'success', "All student accounts suspended"
    else
      notify('error', "No students in list")
  @

  viewStudent: (e) ->
    model = $(e.target).parent().data('model')
    Backbone.history.navigate("students/" + model.id, trigger: true)


                
