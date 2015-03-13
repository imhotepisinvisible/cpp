describe "Company View", ->
  beforeEach ->
    #setFixtures(sandbox id: "app")

    @companyAttrs =
      name: "Google"
      logo: "Logo.jpg"
      description: "Super cool"
      id: 1

    @attrs =
      first_name: 'Captain'
      last_name: 'Test'
      role: 'Tester'
      email: 'test@test.com'
      password: 'cppcppcpp'
      password_confirmation: 'cppcppcpp'
      id: 1
      company_id: 1

    @attrs1 =
      first_name: 'Corporal'
      last_name: 'Junior'
      role: 'Second Tester'
      email: 'test2@test.com'
      password: 'cppcppcpp'
      password_confirmation: 'cppcppcpp'
      id: 2
      company_id: 1

    company = new CPP.Models.Company @companyAttrs
    company_contact = new CPP.Models.CompanyContact @attrs
    company_contact2 = new CPP.Models.CompanyContact @attrs1

    contacts = new CPP.Collections.CompanyContacts

    contacts.add(company_contact)
    contacts.add(company_contact2)
    
    @view = new CPP.Views.Contacts.PartialEdit
      collection: contacts
      company_id: 1
      el: '#app'

    console.log  @view
    #@form = new Backbone.Form schema: {}

  describe "render", ->
      it "should return self", ->
        console.log @view
        expect(@view.render()).toBe(@view)
