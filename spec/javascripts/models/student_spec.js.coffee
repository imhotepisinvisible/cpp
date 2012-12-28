describe "Student", ->
  beforeEach ->
    @attrs = 
      first_name: "Sarah"
      last_name: "Tattersall"
      email: "st@email.com"
      password: "aaaaaaaa"
      password_confirmation: "aaaaaaaa"
      departments: ['doc']
      id: 1

  describe "Routing", ->
    beforeEach ->
      @student = new CPP.Models.Student @attrs

    describe "url", ->
      describe "when no id is set", ->
        it "should return the collection URL", ->
          sinon.stub(@student, "isNew").returns(true)
          expect(@student.url()).toEqual '/students'

      describe "when id is set", ->
        it "should return the collection URL and id", ->
          sinon.stub(@student, "isNew").returns(false)
          expect(@student.url()).toEqual '/students/1'

    describe "initialize", ->
      describe "when navigating to events", ->
        it "should return the students events url", ->
          expect(@student.events.url).toEqual '/students/1/events'


      describe "when navigating to events", ->
        it "should return the students placements url", ->
          expect(@student.placements.url).toEqual '/students/1/placements'

    describe "when instantiated", ->
      it "should be valid", ->
        expect(@student.isValid()).toBeTruthy()

      it "should exhibit first name attribute", ->
        expect(@student.get 'first_name').toEqual @attrs.first_name

      it "should exhibit last_name attribute", ->
        expect(@student.get 'last_name').toEqual @attrs.last_name

      it "should exhibit email attribute", ->
        expect(@student.get 'email').toEqual @attrs.email

      # TODO: THIS ISN'T GOOD?
      it "should not exhibit password attribute", ->
        expect(@student.get 'password').toEqual @attrs.password

      it "should exhibit password_confirmation attribute", ->
        expect(@student.get 'password_confirmation').toEqual @attrs.password

  describe "when saving required fields", ->
    beforeEach ->
      spy = @errorSpy = sinon.spy();
      init = CPP.Models.Student::initialize
      CPP.Models.Student::initialize = ->
        spy(@, "validated:invalid")
        init.call this

      @student = new CPP.Models.Student @attrs

    afterEach ->
      expect(@errorSpy).toHaveBeenCalledOnce()

    it "should not save when first_name is empty", ->
      @student.save 'first_name': ""

    it "should not save when last_name is empty", ->
      @student.save 'last_name': null

    it "should not save when email is empty", ->
      @student.save 'email': null

    it "should not save when email does not match email form", ->
      @student.save 'email': "email"

    it "should not save when password is empty", ->
      @student.save 'password': null

    it "should not save when password is less than 8 characters", ->
      @student.save 'password_confirmation' : 'aaaaaaa'

    it "should not save when password_confirmation is empty", ->
      @student.save 'password_confirmation': ""

    it "should not save when password_confirmation is less than 8 characters", ->
      @student.save 'password_confirmation' : 'aaaaaaa'

    it "should not save when departments is empty", ->
      @student.save 'departments' : null
