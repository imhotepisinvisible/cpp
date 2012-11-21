describe "Company", ->
  beforeEach ->
    @name = "Google"
    @logo = "Logo.jpg"
    @description = "Super cool"

    @eventsCollection = new Backbone.Collection()
    @eventsStub = sinon.stub(window.CPP.Collections, "Events")
                    .returns(@eventsCollection)

    @placementsCollection = new Backbone.Collection()
    @placementsStub = sinon.stub(window.CPP.Collections, "Placements")
                    .returns(@placementsCollection)

    @emailsCollection = new Backbone.Collection()
    @emailsStub = sinon.stub(window.CPP.Collections, "Emails")
                    .returns(@emailsCollection)

    @company = new CPP.Models.Company {
      name: @name
      logo: @logo
      description: @description
      id: 1
    }

  afterEach ->
    window.CPP.Collections.Events.restore()
    window.CPP.Collections.Placements.restore()
    window.CPP.Collections.Emails.restore()

  describe "url", ->
    describe "when no id is set", ->
      it "should return the collection URL", ->
        sinon.stub(@company, 'isNew').returns(true)
        expect(@company.url()).toEqual '/companies'

    describe "when id is set", ->
      it "should return the collection URL and id", ->
        expect(@company.url()).toEqual '/companies/1'

  describe "initialize", ->
    describe "when navigating to events", ->
      it "should return the companies events url", ->
        expect(@company.events.url).toEqual '/companies/1/events'


    describe "when navigating to placements", ->
      it "should return the companies placements url", ->
        expect(@company.placements.url).toEqual '/companies/1/placements'

    describe "when navigating to emails", ->
      it "should return the companies email url", ->
        expect(@company.emails.url).toEqual '/companies/1/emails'


  describe "when instantiated", ->

    it "should exhibit name attribute", ->
      expect(@company.get 'name').toEqual @name

    it "should exhibit logo attribute", ->
      expect(@company.get 'logo').toEqual @logo

    it "should exhibit description attribute", ->
     expect(@company.get 'description').toEqual @description

    describe "events collection", ->
      it "should be exhibited", ->
        expect(@eventsStub).toHaveBeenCalledOnce()

      it "should have a url of /companies/{id}/events", ->
        expect(@eventsCollection.url).toBe '/companies/1/events'

    describe "placements collection", ->
      it "should be exhibited", ->
        expect(@placementsStub).toHaveBeenCalledOnce()

      it "should have a url of /companies/{id}/placements", ->
        expect(@placementsCollection.url).toBe '/companies/1/placements'

    describe "emails collection", ->
      it "should be exhibited", ->
        expect(@emailsStub).toHaveBeenCalledOnce()

      it "should have a url of /companies/{id}/emails", ->
        expect(@emailsCollection.url).toBe '/companies/1/emails'


