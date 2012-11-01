describe "Company", ->
  beforeEach ->
    @name = "Google"
    @logo = "Logo.jpg"
    @description = "Super cool"


    @company = new CPP.Models.Company {
      name: @name
      logo: @logo
      description: @description
    }

  describe "url", ->
    describe "when no id is set", ->
      it "should return the collection URL", ->
        expect(@company.url()).toEqual("/companies")

    describe "when id is set", ->
      it "should return the collection URL and id", ->
        @company.id = 1
        expect(@company.url()).toEqual("/companies/1")

  describe "when instantiated", ->

    it "should exhibit name attribute", ->
      expect(@company.get("name")).toEqual @name

    it "should exhibit logo attribute", ->
      expect(@company.get("logo")).toEqual @logo

    it "should exhibit description attribute", ->
     expect(@company.get("description")).toEqual @description


