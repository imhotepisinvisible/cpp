describe "Placement Routing", ->
  beforeEach ->
    @router = new CPP.Routers.Placements

  describe "Calls correct routing method", ->
    beforeEach ->
      @route_spy = sinon.spy()
      try
        Backbone.history.start
          silent: true
          pushState: true

      @router.navigate "elsewhere"

    it "should call index route with an /placements route", ->
      @router.bind "route:index", @route_spy
      @router.navigate "placements", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call new route with an /placements/{no} route", ->
      @router.bind "route:view", @route_spy
      @router.navigate "placements/1", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call view route with an /placements/{no}/edit route", ->
      @router.bind "route:edit", @route_spy
      @router.navigate "placements/1/edit", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call new route with an /companies/{id}/placements/new", ->
      @router.bind "route:new", @route_spy
      @router.navigate "companies/1/placements/new", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call indexCompany route with an /companies/{id}/placements", ->
      @router.bind "route:indexCompany", @route_spy
      @router.navigate "companies/1/placements", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()


  describe "Handler functionality", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @collection.url = "/placements"
      @fetchStub = sinon.stub(@collection, "fetch").yieldsTo "success"

      @placementsCollectionStub = sinon.stub(window.CPP.Collections, "Placements")
                                   .returns(@collection)

      @placementsEditViewStub = sinon.stub(window.CPP.Views, "PlacementsEdit")
                                  .returns(new Backbone.View())

      @placementsIndexViewStub = sinon.stub(window.CPP.Views, "PlacementsIndex")
                                  .returns(new Backbone.View())

      @model = new Backbone.Model()
      @model.url = "/placements"
      sinon.stub(@model, "fetch").yieldsTo "success"
      sinon.stub(@model, "get").withArgs("company_id").returns(1)

      @placementModelStub = sinon.stub(window.CPP.Models, "Placement")
                             .returns(@model)

      @company = new Backbone.Model()
      @company.url = "/companies"

      @companyModelStub = sinon.stub(window.CPP.Models, "Company")
                            .returns(@company)


    afterEach ->
      window.CPP.Collections.Placements.restore()
      window.CPP.Models.Placement.restore()
      window.CPP.Models.Company.restore()
      window.CPP.Views.Placements.Edit.restore()
      window.CPP.Views.Placements.Index.restore()

    describe "Index handler", ->
      it "should create a Placement collection", ->
        @router.index()
        expect(@placementsCollectionStub).toHaveBeenCalledOnce()
        expect(@placementsCollectionStub).toHaveBeenCalledWith()

      it "should create a PlacementIndex view on fetch success", ->
        @router.index()
        expect(@placementsIndexViewStub).toHaveBeenCalledOnce()
        expect(@placementsIndexViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create a PlacementIndex view on fetch error", ->
        @collection.fetch.restore()
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@placementsIndexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        @router.index()
        expect(@fetchStub).toHaveBeenCalledOnce()
        expect(@fetchStub).toHaveBeenCalledWith()

    describe "New handler", ->
      it "should create a Placement collection", ->
        @router.new(1)
        expect(@placementsCollectionStub).toHaveBeenCalledOnce()
        expect(@placementsCollectionStub).toHaveBeenCalledWith()

      it "should create a Placement model", ->
        @router.new(1)
        expect(@placementModelStub).toHaveBeenCalledOnce()
        expect(@placementModelStub).toHaveBeenCalledWith company_id: 1

      it "should create a PlacementsEdit view", ->
        @router.new(1)
        expect(@placementsEditViewStub).toHaveBeenCalledOnce()
        expect(@placementsEditViewStub).toHaveBeenCalledWith model: @model

    describe "Edit handler", ->
      it "should create a Placement Model", ->
        @router.edit(1)
        expect(@placementModelStub).toHaveBeenCalledOnce()
        expect(@placementModelStub).toHaveBeenCalledWith id: 1

      it "should create a PlacementIndex view on fetch success", ->
        @router.edit(1)
        expect(@placementsEditViewStub).toHaveBeenCalledOnce()
        expect(@placementsEditViewStub).toHaveBeenCalledWith model: @model


      it "should not create a PlacementIndex view on fetch error", ->
        @model.fetch.restore()
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.edit(1)
        expect(@placementsEditViewStub.callCount).toBe 0

    describe "View Handler", ->
      beforeEach ->
        sinon.stub(@company, "fetch").yieldsTo "success"
        @placementsViewStub = sinon.stub(window.CPP.Views, "PlacementsView")
                                .returns(new Backbone.View())

      afterEach ->
        window.CPP.Views.Placements.View.restore()

      it "should create a Placement Model", ->
        @router.view(1)
        expect(@placementModelStub).toHaveBeenCalledOnce()
        expect(@placementModelStub).toHaveBeenCalledWith id: 1

      it "should create a Company model on placement fetch success", ->
        company_id = 2
        @model.company_id = company_id
        @router.view(1)
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: company_id

      it "should not create a Company model on placement fetch error", ->
        @model.fetch.restore()
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.view(1)
        expect(@companyModelStub.callCount).toBe 0

      it "should create a PlacementsView on company fetch success", ->
        @router.view(1)
        expect(@placementsViewStub).toHaveBeenCalledOnce()
        expect(@placementsViewStub).toHaveBeenCalledWith model: @model

      it "should not create a PlacementsView on company fetch error", ->
        @company.fetch.restore()
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.view(1)
        expect(@placementsViewStub.callCount).toBe 0

    describe "IndexCompany Handler", ->
      beforeEach ->
        sinon.stub(@company, "fetch").yieldsTo "success"

      it "should create a Placement collection", ->
        @router.indexCompany(1)
        expect(@placementsCollectionStub).toHaveBeenCalledOnce()
        expect(@placementsCollectionStub).toHaveBeenCalledWith()


      it "should create a Company Model on collection fetch success", ->
        @router.indexCompany(1)
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should not create a Company model on placement fetch error", ->
        @collection.fetch.restore()
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.indexCompany(1)
        expect(@companyModelStub.callCount).toBe 0

      it "should create a PlacementIndex on company fetch success", ->
        @router.indexCompany(1)
        expect(@placementsIndexViewStub).toHaveBeenCalledOnce()
        expect(@placementsIndexViewStub).toHaveBeenCalledWith collection: @collection

      it "should not create a PlacementIndex on company fetch error", ->
        @company.fetch.restore()
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.indexCompany(1)
        expect(@placementsIndexViewStub.callCount).toBe 0
