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
    @emailsStub = sinon.stub(window.CPP.Collections, "TaggedEmails")
                    .returns(@emailsCollection)

    @contactsCollection = new Backbone.Collection()
    @contactsStub = sinon.stub(window.CPP.Collections, "CompanyContacts")
                    .returns(@contactsCollection)

    @departmentsCollection = new Backbone.Collection()
    @departmentsStub = sinon.stub(window.CPP.Collections, "Departments")
                    .returns(@departmentsCollection)

    @company = new CPP.Models.Company {
      name: @name
      logo: @logo
      description: @description
      id: 1
    }

  afterEach ->
    window.CPP.Collections.Events.restore()
    window.CPP.Collections.Placements.restore()
    window.CPP.Collections.TaggedEmails.restore()
    window.CPP.Collections.CompanyContacts.restore()
    window.CPP.Collections.Departments.restore()

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

    describe "when navigating to tagged emails", ->
      it "should return the companies email url", ->
        expect(@company.tagged_emails.url).toEqual '/companies/1/tagged_emails'

    describe "when navigating to contacts", ->
      it "should return the companies contacts url", ->
        expect(@company.company_contacts.url).toEqual '/companies/1/company_contacts'

    describe "when navigating to departments", ->
      it "should return the companies departments url", ->
        expect(@company.departments.url).toEqual '/companies/1/departments'


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

      it "should have a url of /companies/{id}/tagged_emails", ->
        expect(@emailsCollection.url).toBe '/companies/1/tagged_emails'

    describe "contacts collection", ->
      it "should be exhibited", ->
        expect(@contactsStub).toHaveBeenCalledOnce()

      it "should have a url of /companies/{id}/company_contacts", ->
        expect(@contactsCollection.url).toBe '/companies/1/company_contacts'

    describe "departments collection", ->
      it "should be exhibited", ->
        expect(@departmentsStub).toHaveBeenCalledOnce()

      it "should have a url of /companies/{id}/departments", ->
        expect(@departmentsCollection.url).toBe '/companies/1/departments'

