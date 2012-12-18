class CPP.Routers.Students extends Backbone.Router
  routes:
      'students': 'index'
      'students/:id': 'view'
      'students/:id/edit': 'edit'
      'students/:id/settings': 'settings'
      'students/:id/companies' : 'companies'
      'departments/:id/students/signup': 'signup'

  index: ->
    students = new CPP.Collections.Students
    students.fetch
      success: ->
        new CPP.Views.StudentsIndex collection: students
      error: ->
        notify "error", "Couldn't fetch students"

  view: (id) ->
    student = new CPP.Models.Student id: id
    student.fetch
      success: ->
        new CPP.Views.StudentsView model: student
      error: ->
        notify "error", "Couldn't fetch student"


  edit: (id) ->
    student = new CPP.Models.Student id: id
    deferreds = []
    deferreds.push(student.events.fetch({ data: $.param({ limit: 3}) }))
    deferreds.push(student.placements.fetch({ data: $.param({ limit: 3}) }))

    $.when.apply($, deferreds).done(->
      companydeferreds = []
      for e in student.events.models
        do (e) ->
          e.company = new CPP.Models.Company id: e.get 'company_id'
          companydeferreds.push(e.company.fetch())
      for p in student.placements.models
        do (p) ->
          p.company = new CPP.Models.Company id: p.get 'company_id'
          companydeferreds.push(p.company.fetch())

      $.when.apply($, companydeferreds).done(->
        student.fetch
          success: ->
            new CPP.Views.StudentsEdit model: student
          error: ->
            notify "error", "Couldn't fetch student"
      )
    )


  settings: (id) ->
    student = new CPP.Models.Student id: id
    student.events.fetch({ data: $.param({ limit: 3}) })
    student.placements.fetch({ data: $.param({ limit: 3}) })
    student.fetch
      success: ->
        new CPP.Views.StudentsSettings model: student
      error: ->
        notify "error", "Couldn't fetch student"

  signup: (department_id) ->
    student = new CPP.Models.Student departments: [department_id]
    student.collection = new CPP.Collections.Students
    new CPP.Views.StudentsSignup model: student

  # The company index page that students will see
  companies: (id) ->
    student = new CPP.Models.Student id: id
    companies = new CPP.Collections.Companies
    companies.fetch
      success: ->
        new CPP.Views.CompaniesStudentIndex collection: companies
      error: ->
        notify "error", "Couldn't fetch companies"
