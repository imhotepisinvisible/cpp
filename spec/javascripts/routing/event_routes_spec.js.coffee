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

      @eventEditViewStub = sinon.stub(window.CPP.Views, "EventsEdit")
                            .returns(new Backbone.View())

      @model = new (Backbone.Model.extend(
                   schema:
                      title:
                        type: "Text"
                  ))()
      @model.url = "/events"

      @eventModelStub = sinon.stub(window.CPP.Models, "Event")
                          .returns(@model)

    afterEach ->
      window.CPP.Views.EventsEdit.restore()
      window.CPP.Collections.Events.restore()
      window.CPP.Models.Event.restore()

    describe "Index handler", ->
      beforeEach ->
        @eventIndexViewStub = sinon.stub(window.CPP.Views, "EventsIndex")
                               .returns(new Backbone.View())
      afterEach ->
        window.CPP.Views.EventsIndex.restore()

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
      beforeEach ->
        @router.new(1)

      it "should create an Event collection", ->
        expect(@eventsCollectionStub).toHaveBeenCalledOnce()
        expect(@eventsCollectionStub).toHaveBeenCalledWithExactly()

      it "should create an Event model", ->
        expect(@eventModelStub).toHaveBeenCalledOnce()
        expect(@eventModelStub).toHaveBeenCalledWith company_id: 1

      it "should create an EventEdit view success", ->
        expect(@eventEditViewStub).toHaveBeenCalledOnce()
        expect(@eventEditViewStub).toHaveBeenCalledWith model: @model

    describe "Edit handler", ->
      # TODO: Why does this test cause:
      # Uncaught TypeError: Cannot read property '$el' of undefined
      it "should create an Event model", ->
        @router.edit(1)
        expect(@eventModelStub).toHaveBeenCalledOnce()
        expect(@eventModelStub).toHaveBeenCalledWith id: 1

      it "should create an EventEdit view on fetch success", ->
        sinon.stub(@model, "fetch").yieldsTo "success"
        @router.edit(1)
        expect(@eventEditViewStub).toHaveBeenCalledOnce()
        expect(@eventEditViewStub).toHaveBeenCalledWith model: @model


      it "should not create an EventEdit view on fetch success", ->
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.edit(1)
        expect(@eventEditViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        fetch_stub = sinon.stub(@model, "fetch").returns(null)
        @router.edit(1)
        expect(fetch_stub).toHaveBeenCalledOnce()
        expect(fetch_stub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @company = new Backbone.Model()
        @company.url = "/companies"

        @companyModelStub = sinon.stub(window.CPP.Models, "Company")
                            .returns(@company)

        @eventsViewStub = sinon.stub(window.CPP.Views, "EventsView")
                            .returns(new Backbone.View())


      afterEach ->
        window.CPP.Models.Company.restore()
        window.CPP.Views.EventsView.restore()

      it "should create an Event model", ->
        @router.view(1)
        expect(@eventModelStub).toHaveBeenCalledOnce()
        expect(@eventModelStub).toHaveBeenCalledWith id: 1

      it "should create a Company Model on fetch success", ->
        company_id = 2
        @model.company_id = company_id
        sinon.stub(@model, "fetch").yieldsTo "success"
        @router.view(1)
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: company_id

      it "should not create a Company Model on fetch error", ->
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.view(1)
        expect(@companyModelStub.callCount).toBe 0

      it "should create an EventsView on company fetch success", ->
        sinon.stub(@model, "fetch").yieldsTo "success"
        sinon.stub(@company, "fetch").yieldsTo "success"
        @router.view(1)
        expect(@eventsViewStub).toHaveBeenCalledOnce()

      it "should not create an EventsView on company fetch error", ->
        sinon.stub(@model, "fetch").yieldsTo "success"
        sinon.stub(@company, "fetch").yieldsTo "error"
        @router.edit(1)
        expect(@eventsViewStub.callCount).toBe 0




