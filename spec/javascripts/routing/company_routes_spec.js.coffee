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

      @companiesCollectionStub = sinon.stub(window.CPP.Collections, "Companies")
                                  .returns(@collection)

      @model = new Backbone.Model()
      @model.url = "/companies"
      @model.events = new Backbone.Model()
      @model.events.url = "/events"
      @model.placements = new Backbone.Model()
      @model.placements.url = "/placements"

      @companyModelStub = sinon.stub(window.CPP.Models, "Company")
                            .returns(@model)
      # @modelFetchStub = sinon.stub(@model, "fetch").yieldsTo("success")


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
        sinon.stub(@collection, "fetch").yieldsTo "success"
        @router.index()
        expect(@companiesIndexViewStub).toHaveBeenCalledOnce()
        expect(@companiesIndexViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create an EventIndex view on fetch error", ->
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@companiesIndexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        fetch_stub = sinon.stub(@collection, "fetch").returns(null)
        @router.index()
        expect(fetch_stub).toHaveBeenCalledOnce()
        expect(fetch_stub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @companiesViewStub = sinon.stub(window.CPP.Views, "CompaniesView")
                               .returns(new Backbone.View())
      afterEach ->
        window.CPP.Views.CompaniesView.restore()

      it "should create a Company model", ->
        @router.view(1)
        expect(@companyModelStub).toHaveBeenCalledOnce
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should create an CompaniesView on fetch success", ->
        sinon.stub(@model, "fetch").yieldsTo "success"
        @router.view(1)
        expect(@companiesViewStub).toHaveBeenCalledOnce()
        expect(@companiesViewStub).toHaveBeenCalledWith model: @model


      it "should not create an CompaniesView on fetch error", ->
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.view()
        expect(@companiesViewStub.callCount).toBe 0

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
        sinon.stub(@model, "fetch").yieldsTo "success"
        @router.edit(1)
        expect(@companiesEditViewStub).toHaveBeenCalledOnce()
        expect(@companiesEditViewStub).toHaveBeenCalledWith model: @model


      it "should not create an EditView view on fetch error", ->
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.edit(1)
        expect(@companiesEditViewStub.callCount).toBe 0

