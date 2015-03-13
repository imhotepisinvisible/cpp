describe "Companies Student Index View", ->
  beforeEach ->
    setFixtures(sandbox id: "app")

    @attrs1 = 
      id: 1
      name: "1"

    @attrs2 =
      id: 1
      name: "2"

    c1 = new CPP.Models.Company @attrs1
    c2 = new CPP.Models.Company @attrs2
    cc = new CPP.Collections.Companies 
    cc.add(c1)
    cc.add(c2)

    view = new CPP.Views.CompaniesStudentIndex collection: cc
                 
  describe "render", ->
    it "should return self", ->
      console.log cc
      expect(@view.render()).toBeDefined()
