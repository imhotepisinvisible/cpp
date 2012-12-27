describe "Company Routing", ->
  beforeEach ->
      @router = new CPP.Routers.Companies

    describe "Calls correct routing method", ->
      beforeEach ->
        @route_spy = sinon.spy()
        try
          Backbone.history.start
            silent: true
            pushState: true

        @router.navigate "elsewhere"

      it "should call index route with an /companies route", ->
        @router.bind "route:index", @route_spy
        @router.navigate "companies", true
        expect(@route_spy).toHaveBeenCalledOnce()
        expect(@route_spy).toHaveBeenCalledWith()

      it "should call new route with an /companies/{no} route", ->
        @router.bind "route:view", @route_spy
        @router.navigate "companies/1", true
        expect(@route_spy).toHaveBeenCalledOnce()
        expect(@route_spy).toHaveBeenCalledWith()

      it "should call view route with an /companies/{no}/edit route", ->
        @router.bind "route:edit", @route_spy
        @router.navigate "companies/1/edit", true
        expect(@route_spy).toHaveBeenCalledOnce()
        expect(@route_spy).toHaveBeenCalledWith()

  describe "Handler functionality", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @collection.url = "/companies"
      @collectionFetchStub = sinon.stub(@collection, "fetch").yieldsTo "success"

      @companiesCollectionStub = sinon.stub(window.CPP.Collections, "Companies")
                                  .returns(@collection)

      @company = new Backbone.Model()
      @company.url = "/companies"
      @company.events = new Backbone.Collection()
      @company.events.url = "/events"
      sinon.stub(@company.events, "fetch")
      @company.placements = new Backbone.Collection()
      @company.placements.url = "/placements"
      sinon.stub(@company.placements, "fetch")
      @company.tagged_emails = new Backbone.Collection()
      @company.tagged_emails.url = "/tagged_emails"
      sinon.stub(@company.tagged_emails, "fetch")
      @company.company_contacts = new Backbone.Collection()
      @company.company_contacts.url = "/company_contacts"
      sinon.stub(@company.company_contacts, "fetch")
      @company.departments = new Backbone.Collection()
      @company.departments.url = "/departments"
      sinon.stub(@company.departments, "fetch")

      sinon.stub(@company, "fetch").yieldsTo "success"

      @companyModelStub = sinon.stub(window.CPP.Models, "Company")
                            .returns(@company)


    afterEach ->
        window.CPP.Collections.Companies.restore()
        window.CPP.Models.Company.restore()

    describe "Index handler", ->
      beforeEach ->
        @companiesIndexViewStub = sinon.stub(window.CPP.Views, "CompaniesIndex")
                               .returns(new Backbone.View())
      afterEach ->
        window.CPP.Views.CompaniesIndex.restore()

      it "should create an Event collection", ->
        @router.index()
        expect(@companiesCollectionStub).toHaveBeenCalledOnce()
        expect(@companiesCollectionStub).toHaveBeenCalledWithExactly()

      it "should create an EventIndex view on fetch success", ->
        @router.index()
        expect(@companiesIndexViewStub).toHaveBeenCalledOnce()
        expect(@companiesIndexViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create an EventIndex view on fetch error", ->
        @collection.fetch.restore()
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@companiesIndexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        @router.index()
        expect(@collectionFetchStub).toHaveBeenCalledOnce()
        expect(@collectionFetchStub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @companiesViewStub = sinon.stub(window.CPP.Views, "CompaniesView")
                               .returns(new Backbone.View())
      afterEach ->
        window.CPP.Views.CompaniesView.restore()

      it "should create a Company model", ->
        @router.view(1)
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should create a CompaniesView on fetch success", ->
        @router.view(1)
        expect(@companiesViewStub).toHaveBeenCalledOnce()
        expect(@companiesViewStub).toHaveBeenCalledWith model: @company

      it "should not create a CompaniesView on fetch error", ->
        @company.fetch.restore()
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.view(1)
        expect(@companiesViewStub.callCount).toBe 0

      # TOOD: Work out how to test deferreds
      # it "should not create a CompaniesView on company events error", ->
      #   @company.events.fetch.restore()
      #   sinon.stub(@company.events, "fetch").yieldsTo("failure", @company.events)
      #   @router.view(1)
      #   expect(@companiesViewStub.callCount).toBe 0

    describe "Edit handler", ->
      beforeEach ->
        @companiesEditViewStub = sinon.stub(window.CPP.Views, "CompaniesEdit")
                               .returns(new Backbone.View())
      afterEach ->
        window.CPP.Views.CompaniesEdit.restore()

      it "should create a Company model", ->
        @router.edit(1)
        expect(@companyModelStub).toHaveBeenCalledOnce
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should create an EditView view on fetch success", ->
        @router.edit(1)
        expect(@companiesEditViewStub).toHaveBeenCalledOnce()
        expect(@companiesEditViewStub).toHaveBeenCalledWith model: @company


      it "should not create an EditView view on fetch error", ->
        @company.fetch.restore()
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.edit(1)
        expect(@companiesEditViewStub.callCount).toBe 0

