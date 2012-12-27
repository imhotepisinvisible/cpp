describe "Student Routing", ->
  beforeEach ->
    @router = new CPP.Routers.Students

  describe "Calls correct routing method", ->
    beforeEach ->
      @routeSpy = sinon.spy()
      try
        Backbone.history.start
          silent: true
          pushState: true

      @router.navigate "elsewhere"

    it "should call index route with an /students route", ->
      @router.bind "route:index", @routeSpy
      @router.navigate "students", true
      expect(@routeSpy).toHaveBeenCalledOnce()
      expect(@routeSpy).toHaveBeenCalledWith()

    it "should call new route with an /students/{no} route", ->
      @router.bind "route:view", @routeSpy
      @router.navigate "students/1", true
      expect(@routeSpy).toHaveBeenCalledOnce()
      expect(@routeSpy).toHaveBeenCalledWith()

    it "should call view route with an /students/{no}/edit route", ->
      @router.bind "route:edit", @routeSpy
      @router.navigate "students/1/edit", true
      expect(@routeSpy).toHaveBeenCalledOnce()
      expect(@routeSpy).toHaveBeenCalledWith()

    it "should call signup route with a departments/{id}/students/signup route", ->
      @router.bind "route:signup", @routeSpy
      @router.navigate "departments/1/students/signup", true
      expect(@routeSpy).toHaveBeenCalledOnce()
      expect(@routeSpy).toHaveBeenCalledWith()


  describe "Handler functionality", ->
    beforeEach ->
      @student_id = 1
      @collection = new Backbone.Collection()
      @collection.url = "/students"
      @studentCollectionStub = sinon.stub(window.CPP.Collections, "Students")
                                   .returns(@collection)

      @student = new (Backbone.Model.extend(
           schema:
              title:
                type: "Text"
          ))()
      @student.url = "/students/1"
      sinon.stub(@student, "fetch").yieldsTo "success"

      @student.events = new Backbone.Model()
      @student.placements = new Backbone.Model()
      @student.events.url = "/events"
      @student.placements.url = "/placements"

      @studentModelStub = sinon.stub(window.CPP.Models, "Student")
                            .returns(@student)

    afterEach ->
      window.CPP.Collections.Students.restore()
      window.CPP.Models.Student.restore()


    describe "Index handler", ->
      it "should create a Student collection", ->
        @router.index()
        expect(@studentCollectionStub).toHaveBeenCalledOnce()
        expect(@studentCollectionStub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @viewStub = sinon.stub(window.CPP.Views.Students, "View")
                              .returns(new Backbone.View())

      afterEach ->
        window.CPP.Views.Students.View.restore()

      it "should create a Student model", ->
        @router.view @student_id
        expect(@studentModelStub).toHaveBeenCalledOnce()
        expect(@studentModelStub).toHaveBeenCalledWith()


      it "should create a StudentsView on student fetch success", ->
        @router.view @student_id
        expect(@viewStub).toHaveBeenCalledOnce()
        expect(@viewStub).toHaveBeenCalledWith model: @student

      it "should not create a StudentsView on student fetch error", ->
        @student.fetch.restore()
        sinon.stub(@student, "fetch").yieldsTo "error"
        @router.view @student_id
        expect(@viewStub.callCount).toBe 0

    describe "Signup Handler", ->
      beforeEach ->
        @studentSignupViewStub = sinon.stub(window.CPP.Views.Students, "Signup")
                                   .returns(new Backbone.View())
        @router.signup @student_id

      afterEach ->
        window.CPP.Views.Students.Signup.restore()

      it "should create a new Student Model", ->
        expect(@studentModelStub).toHaveBeenCalledOnce()

      it "shpould create a new student collection", ->
        expect(@studentCollectionStub).toHaveBeenCalledOnce()
        expect(@studentCollectionStub).toHaveBeenCalledWith()

      it "should create a new StudentSignup view", ->
        expect(@studentSignupViewStub).toHaveBeenCalledOnce()
        expect(@studentSignupViewStub).toHaveBeenCalledWith model: @student
