CPP.Views.Departments ||= {}

class CPP.Views.Departments.EditAdministrators extends CPP.Views.Base
  
  template: JST['backbone/templates/departments/edit_admins']

  initialize: (options) ->
    admins = new CPP.Collections.DepartmentAdministrators
    admins.fetch
      data: $.param({ department_id: @model.id })
      success: =>
        @collection = admins
        @render()
      error: =>
        notify 'error', 'Could not fetch department administrators'

  render: ->
    $(@el).html(@template(admin: @model))
    if @collection.length > 0
      @collection.each (admin) =>
        view = new CPP.Views.Departments.EditAdministrator
          model: admin
        @$('#admins').append(view.render().el)
    else
      @$('#admins').append "No administrators!"