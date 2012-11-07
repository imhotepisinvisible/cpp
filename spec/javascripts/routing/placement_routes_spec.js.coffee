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
