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
