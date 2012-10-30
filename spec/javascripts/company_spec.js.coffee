describe "Company", ->
  describe "when instantiated", ->
    beforeEach ->
      @name = "Google"
      @logo = "Logo.jpg"
      @description = "Super cool"


      @company = new CPP.Models.Company {
        name: @name
        logo: @logo
        description: @description
      }

    it "should exhibit name attribute", ->
      expect(@company.get("name")).toEqual @name

    it "should exhibit logo attribute", ->
      expect(@company.get("logo")).toEqual @logo

    it "should exhibit description attribute", ->
     expect(@company.get("description")).toEqual @description


