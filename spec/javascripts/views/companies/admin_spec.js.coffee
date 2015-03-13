describe "Company Admin View", ->
  beforeEach ->
    @attrs = 
      id: 1
      name: "Google"
      decription: "Crazy"
      logo: "logo.jpg"
      departments: [1]

    company = new CPP.Models.Company @attrs

    @view = new CPP.Views.Companies.Admin model: company

  describe "render", ->
    it "should return self", ->
      expect(@view.render()).toBeDefined()