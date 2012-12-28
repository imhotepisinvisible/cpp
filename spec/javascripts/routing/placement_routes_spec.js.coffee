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
      @placements = new Backbone.Collection()
      @placements.url = "/placements"
      @fetchStub = sinon.stub(@placements, "fetch").yieldsTo "success"

      @placementsCollectionStub = sinon.stub(window.CPP.Collections, "Placements")
                                   .returns(@placements)

      @editViewStub = sinon.stub(window.CPP.Views.Placements, "Edit")
                                  .returns(new Backbone.View())

      @indexViewStub = sinon.stub(window.CPP.Views.Placements, "Index")
                                  .returns(new Backbone.View())

      @company_id = 2
      @placement = new Backbone.Model()
      @placement.url = "/placements"
      sinon.stub(@placement, "fetch").yieldsTo "success"
      sinon.stub(@placement, "get").withArgs("company_id").returns @company_id

      @placementModelStub = sinon.stub(window.CPP.Models, "Placement")
                             .returns(@placement)

      @company = new Backbone.Model()
      @company.url = "/companies"
      sinon.stub(@company, "fetch").yieldsTo "success"

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
        expect(@indexViewStub).toHaveBeenCalledOnce()
        expect(@indexViewStub).toHaveBeenCalledWith collection: @placements


      it "should not create a Index view on fetch error", ->
        @placements.fetch.restore()
        sinon.stub(@placements, "fetch").yieldsTo "error"
        @router.index()
        expect(@indexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        @router.index()
        expect(@fetchStub).toHaveBeenCalledOnce()
        expect(@fetchStub).toHaveBeenCalledWith()

    describe "New handler", ->
      beforeEach ->
        departments = new Backbone.Collection()
        sinon.stub(departments, "fetch").yieldsTo "success"
        @departmentsStub = sinon.stub(window.CPP.Collections, "Departments").returns(departments)
        @router.new(1)

      afterEach ->
        window.CPP.Collections.Departments.restore()

      it "should create a Placement collection", ->
        expect(@placementsCollectionStub).toHaveBeenCalledOnce()
        expect(@placementsCollectionStub).toHaveBeenCalledWith()

      it "should create a Placement model", ->
        expect(@placementModelStub).toHaveBeenCalledOnce()
        expect(@placementModelStub).toHaveBeenCalledWith company_id: 1

      it "should create a Company Model", ->
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should create a Department Collection on company fetch success", ->
        expect(@departmentsStub).toHaveBeenCalledOnce()

      it "should create a Edit view", ->
        expect(@editViewStub).toHaveBeenCalledOnce()
        expect(@editViewStub).toHaveBeenCalledWith model: @placement

    describe "Edit handler", ->
      it "should create a Placement Model", ->
        @router.edit(1)
        expect(@placementModelStub).toHaveBeenCalledOnce()
        expect(@placementModelStub).toHaveBeenCalledWith id: 1

      it "should create a Index view on fetch success", ->
        @router.edit(1)
        expect(@editViewStub).toHaveBeenCalledOnce()
        expect(@editViewStub).toHaveBeenCalledWith model: @placement


      it "should not create a Index view on fetch error", ->
        @placement.fetch.restore()
        sinon.stub(@placement, "fetch").yieldsTo "error"
        @router.edit(1)
        expect(@editViewStub.callCount).toBe 0

    describe "View Handler", ->
      beforeEach ->
        @viewStub = sinon.stub(window.CPP.Views.Placements, "View")
                                .returns(new Backbone.View())

      afterEach ->
        window.CPP.Views.Placements.View.restore()

      it "should create a Placement Model", ->
        @router.view(1)
        expect(@placementModelStub).toHaveBeenCalledOnce()
        expect(@placementModelStub).toHaveBeenCalledWith id: 1

      it "should create a Company model on placement fetch success", ->
        @router.view(1)
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: @company_id

      it "should not create a Company model on placement fetch error", ->
        @placement.fetch.restore()
        sinon.stub(@placement, "fetch").yieldsTo "error"
        @router.view(1)
        expect(@companyModelStub.callCount).toBe 0

      it "should create a View on company fetch success", ->
        @router.view(1)
        expect(@viewStub).toHaveBeenCalledOnce()
        expect(@viewStub).toHaveBeenCalledWith model: @placement

      it "should not create a View on company fetch error", ->
        @company.fetch.restore()
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.view(1)
        expect(@viewStub.callCount).toBe 0

    describe "IndexCompany Handler", ->
      it "should create a Placement collection", ->
        @router.indexCompany(1)
        expect(@placementsCollectionStub).toHaveBeenCalledOnce()
        expect(@placementsCollectionStub).toHaveBeenCalledWith()


      it "should create a Company Model on collection fetch success", ->
        @router.indexCompany(1)
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should not create a Company model on placement fetch error", ->
        @placements.fetch.restore()
        sinon.stub(@placements, "fetch").yieldsTo "error"
        @router.indexCompany(1)
        expect(@companyModelStub.callCount).toBe 0

      it "should create a Index view on company fetch success", ->
        @router.indexCompany(1)
        expect(@indexViewStub).toHaveBeenCalledOnce()
        expect(@indexViewStub).toHaveBeenCalledWith collection: @placements

      it "should not create a Index view on company fetch error", ->
        @company.fetch.restore()
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.indexCompany(1)
        expect(@indexViewStub.callCount).toBe 0
