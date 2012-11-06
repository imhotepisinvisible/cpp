describe "Event Routing", ->
  beforeEach ->
    @router = new CPP.Routers.Events

  describe "Calls correct routing method", ->
    beforeEach ->
      @route_spy = sinon.spy()
      try
        Backbone.history.start
          silent: true
          pushState: true

      @router.navigate "elsewhere"

    it "should call index route with an /events route", ->
      @router.bind "route:index", @route_spy
      @router.navigate "events", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call new route with an /events/{no} route", ->
      @router.bind "route:view", @route_spy
      @router.navigate "events/1", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call view route with an /events/{no}/edit route", ->
      @router.bind "route:edit", @route_spy
      @router.navigate "events/1/edit", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call new route with an /companies/{id}/events/new", ->
      @router.bind "route:new", @route_spy
      @router.navigate "companies/1/events/new", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call indexCompany route with an /companies/{id}/events", ->
      @router.bind "route:indexCompany", @route_spy
      @router.navigate "companies/1/events", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()


  describe "Handler functionality", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @collection.url = "/events"

      @eventsCollectionStub = sinon.stub(window.CPP.Collections, "Events")
                                .returns(@collection)

      @eventIndexViewStub = sinon.stub(window.CPP.Views, "EventsIndex")
                         .returns(new Backbone.View())

      @eventEditViewStub = sinon.stub(window.CPP.Views, "EventsEdit")
                         .returns(new Backbone.View())

      @model = new (Backbone.Model.extend(
                   schema:
                      title:
                        type: "Text"
                  ))()

      @eventModelStub = sinon.stub(window.CPP.Models, "Event")
                          .returns(@model)


    afterEach ->
      window.CPP.Views.EventsIndex.restore()
      window.CPP.Views.EventsEdit.restore()
      window.CPP.Collections.Events.restore()
      window.CPP.Models.Event.restore()

    describe "Index handler", ->
      it "should create an Event collection", ->
        @router.index()
        expect(@eventsCollectionStub).toHaveBeenCalledOnce()
        expect(@eventsCollectionStub).toHaveBeenCalledWithExactly()

      it "should create an EventIndex view on fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "success"
        @router.index()
        expect(@eventIndexViewStub).toHaveBeenCalledOnce()
        expect(@eventIndexViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create an EventIndex view on fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@eventIndexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        fetch_stub = sinon.stub(@collection, "fetch").returns(null)
        @router.index()
        expect(fetch_stub).toHaveBeenCalledOnce()
        expect(fetch_stub).toHaveBeenCalledWith()

    describe "New handler", ->
      it "should create an Event collection", ->
        @router.new(1)
        expect(@eventsCollectionStub).toHaveBeenCalledOnce()
        expect(@eventsCollectionStub).toHaveBeenCalledWithExactly()

      it "should create an Event model", ->
        @router.new(1)
        expect(@eventModelStub).toHaveBeenCalledOnce()
        expect(@eventModelStub).toHaveBeenCalledWith()

      it "should create an EventEdit view success", ->
        @router.new(1)
        expect(@eventEditViewStub).toHaveBeenCalledOnce()
        expect(@eventEditViewStub).toHaveBeenCalledWith model: @model



