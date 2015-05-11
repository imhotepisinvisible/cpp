describe "Company View", ->
  
  beforeEach ->
    setFixtures(sandbox id: "app")

    @attrs = 
      id: 1
      name: "Google"
      decription: "Crazy"

    company = new CPP.Models.Company @attrs

    @view = new CPP.Views.CompaniesView
                    model: company

  describe "render", ->
    it "should return self", ->
      expect(@view.render()).toBe(@view)

  describe "company highlight", ->
    it "should call the function highlight", ->
      expect(@view.companyHighlight).toBeDefined()


      # expect(@view.$el).toContain(@at

  # describe "blah", ->
  #   it "blah blah", ->
  #     @view.render()
  #     console.log $(@view.el).html()
  #     console.log @view.$el.find('a').attr('href')
  #     expect(@view.$el.find('a')).toHaveAttr('href', '/#events/')
