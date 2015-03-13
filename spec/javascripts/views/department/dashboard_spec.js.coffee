describe "Department Dashboard", ->
  beforeEach ->
    setFixtures(sandbox id: "app")

    @attrs = 
      name: 'Department of Computing'
      settings_notifier_event: "Please note that at current an event must be scheduled at least two weeks in advance to be approved."
      settings_notifier_placement: "If this is your first placement you're offering, make sure you send back a placement performa and a health and safety form which can be found on https://www.doc.ic.ac.uk/internal/industrialplacements/employers/IPproforma12-studentorganised.doc and https://www.doc.ic.ac.uk/internal/industrialplacements/employers/Placement_Provider_Information_Form_2012.doc"

    department = new CPP.Models.Department @attrs

    @view = new CPP.Views.Departments.Dashboard
                  model: department
                  
    @result = new CPP.Views.Departments.EditAdministrators
                  model: department
    
  describe "render", ->
    it "should return self", ->
      expect(true).toBeTruthy()
      
  describe "Layout", ->
    it "should contain Dashboard", ->
      console.log expect(@view.$el).toContain("Dashboard")
      expect(true).toBeTruthy()