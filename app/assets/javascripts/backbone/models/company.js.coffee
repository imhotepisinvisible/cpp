class CPP.Models.Company extends CPP.Models.Base
  initialize: ->
    @hidden = false;

    @events = new CPP.Collections.Events
    @events.url = '/companies/' + this.id + '/events'

    @placements = new CPP.Collections.Placements
    @placements.url = '/companies/' + this.id + '/placements'

    @emails = new CPP.Collections.Emails
    @emails.url = '/companies/' + this.id + '/emails'

    @company_contacts = new CPP.Collections.CompanyContacts
    @company_contacts.url = '/companies/' + this.id + '/company_contacts'

    #@departments = new CPP.Collections.Departments
    #@departments.url = '/companies/' + this.id + '/departments'

    #@allDepartments = new CPP.Collections.Departments
    #@allDepartments.url = '/departments'

  toString: ->
    return this.get 'name'

  url: ->
    '/companies' + (if @isNew() then '' else '/' + @id)

  getStarClass: ->
    if @get('rating') == 1
      return "golden-star icon-star"
    return "icon-star-empty"

  getBanClass: ->
    if @get('rating') == 3
      return "red-ban icon-ban-circle"
    return "icon-ban-circle"

  getStatus: ()->
    return window.approvalStatusMap(@get('status')).split(',')[0]
    
  validation:
    name:
      required: true
    description:
      required: true
    departments:
      required: true

  schema: ->
    name:
      type: "Text"
      title: "Name*"
    description:
      type: "TextArea"
      title: "Description*"
    career_link:
      type: "Text"
      title: "Career Page URL"
    #departments:
    #  type: "Checkboxes"
    #  title: "Departments*"
    #  options: @allDepartments
    #  editorClass: "departments-checkbox"


class CPP.Collections.Companies extends CPP.Collections.Base
  url: '/companies'
  model: CPP.Models.Company
  comparator: (company) ->
    return company.get "rating"

class CPP.Collections.CompaniesPager extends Backbone.PageableCollection
  model: CPP.Models.Company
  url: '/companies'
  mode: 'client' 

  state:
    pageSize: 20
