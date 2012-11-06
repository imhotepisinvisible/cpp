describe "Event Routing", ->
  beforeEach ->
    @router = new CPP.Routers.Events

  describe "Calls correct routing method", ->
    beforeEach ->
      @routeSpy = sinon.spy()
      try
        Backbone.history.start
          silent: true
          pushState: true

      @router.navigate "elsewhere"

    it "should call index route with an events hash", ->
      @router.bind "route:index", @routeSpy
      @router.navigate "events", true
      expect(@routeSpy).toHaveBeenCalledOnce()
      expect(@routeSpy).toHaveBeenCalledWith()

  describe "Collection and views initialized", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @collection.url = "/events"

      @eventViewStub = sinon.stub(window.CPP.Views, "EventsIndex")
                         .returns(new Backbone.View())
      @eventsCollectionStub = sinon.stub(window.CPP.Collections, "Events")
                                .returns(@collection)

    afterEach ->
      window.CPP.Views.EventsIndex.restore()
      window.CPP.Collections.Events.restore()

    describe "Index handler", ->
      it "should create a Event collection", ->
        @router.index()
        expect(@eventsCollectionStub).toHaveBeenCalledOnce()
        expect(@eventsCollectionStub).toHaveBeenCalledWithExactly()

      it "should create an EventIndex view on fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "success"
        @router.index()
        expect(@eventViewStub).toHaveBeenCalledOnce()
        expect(@eventViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create an EventIndex view on fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@eventViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        fetch_stub = sinon.stub(@collection, "fetch").returns(null)
        @router.index()
        expect(fetch_stub).toHaveBeenCalledOnce()
        expect(fetch_stub).toHaveBeenCalledWith()



