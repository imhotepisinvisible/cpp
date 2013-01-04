CPP.Views.Departments ||= {}

class CPP.Views.Departments.Approvals extends CPP.Views.Base
  template: JST['backbone/templates/departments/approvals']

  initialize: (options) ->
    @model.pending_companies.fetch
      success: =>
        @collection = @model.pending_companies
        @render()
      error: ->
        notify 'error', 'Could not fetch approval requests'

  render: ->
    $(@el).html(@template(dept: @model))
    if @collection.length > 0
      @collection.each (company) =>
        view = new CPP.Views.Departments.Approval
          model: company
          dept: @model
        @$('#approvals').append(view.render().el)
    else
      @$('#approvals').append "No pending requests!"