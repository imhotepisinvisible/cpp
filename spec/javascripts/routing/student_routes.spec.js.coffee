describe "Student Routing", ->
  beforeEach ->
    @router = new CPP.Routers.Students

  describe "Calls correct routing method", ->
    beforeEach ->
      @route_spy = sinon.spy()
      try
        Backbone.history.start
          silent: true
          pushState: true

      @router.navigate "elsewhere"

    it "should call index route with an /students route", ->
      @router.bind "route:index", @route_spy
      @router.navigate "students", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call new route with an /students/{no} route", ->
      @router.bind "route:view", @route_spy
      @router.navigate "students/1", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()

    it "should call view route with an /students/{no}/edit route", ->
      @router.bind "route:edit", @route_spy
      @router.navigate "students/1/edit", true
      expect(@route_spy).toHaveBeenCalledOnce()
      expect(@route_spy).toHaveBeenCalledWith()


  describe "Handler functionality", ->
    describe "Index handler", ->
      beforeEach ->
        @collection = new Backbone.Collection()
        @collection.url = "/students"

        @studentCollectionStub = sinon.stub(window.CPP.Collections, "Students")
                                     .returns(@collection)
      afterEach ->
        window.CPP.Collections.Students.restore()

      it "should create a Student collection", ->
        @router.index()
        expect(@studentCollectionStub).toHaveBeenCalledOnce()
        expect(@studentCollectionStub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @model = new (Backbone.Model.extend(
                   schema:
                      title:
                        type: "Text"
                  ))()
        @model.url = "/students/1"

        @model.events = new Backbone.Model()
        @model.placements = new Backbone.Model()
        @model.events.url = "/events"
        @model.placements.url = "/placements"

        @studentModelStub = sinon.stub(window.CPP.Models, "Student")
                              .returns(@model)

        @studentViewStub = sinon.stub(window.CPP.Views, "StudentsView")
                              .returns(new Backbone.View())

      afterEach ->
        window.CPP.Models.Student.restore()
        window.CPP.Views.StudentsView.restore()

      it "should create a Student model", ->
        @router.view()
        expect(@studentModelStub).toHaveBeenCalledOnce()
        expect(@studentModelStub).toHaveBeenCalledWith()


      it "should create a StudentsView on student fetch success", ->
        sinon.stub(@model, "fetch").yieldsTo "success"
        @router.view()
        expect(@studentViewStub).toHaveBeenCalledOnce()
        expect(@studentViewStub).toHaveBeenCalledWith model: @model

      it "should not create a StudentsView on student fetch error", ->
        sinon.stub(@model, "fetch").yieldsTo "error"
        @router.view()
        expect(@studentViewStub.callCount).toBe 0
