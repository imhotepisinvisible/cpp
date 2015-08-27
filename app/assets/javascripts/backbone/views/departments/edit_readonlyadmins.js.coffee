CPP.Views.Departments ||= {}

class CPP.Views.Departments.EditReadonlyAdministrators extends CPP.Views.Base

  template: JST['backbone/templates/departments/edit_admins']

  # Fetch administrators for department
  initialize: (options) ->
    admins = new CPP.Collections.ReadonlyAdministrators
    admins.fetch
      data: $.param({ department_id: @model.id })
      success: =>
        @collection = admins
        @render()
      error: =>
        notify 'error', 'Could not fetch read only administrators'

  # For each administrator show the edit administrator partial view
  render: ->
    $(@el).html(@template(admin: @model))
    if @collection.length > 0
      @collection.each (admin) =>
        view = new CPP.Views.Departments.EditAdministrator
          model: admin
        @$('#admins').append(view.render().el)
    else
      @$('#admins').append "No read only administrators!"
