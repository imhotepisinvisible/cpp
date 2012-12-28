describe "Event", ->
  beforeEach ->
    @attrs = 
      title: "Google interview techniques"
      description: "Ace our interviews"
      location: "Victoria, London"
      start_date: new Date
      end_date: new Date


  describe "url", ->
    beforeEach ->
      @event = new CPP.Models.Event @attrs

    describe "when no id is set", ->
      it "should return the collection URL", ->
        expect(@event.url()).toEqual '/events'

    describe "when id is set", ->
      it "should return the collection URL and id", ->
        @event.id = 1
        expect(@event.url()).toEqual '/events/1'

  describe "when instantiated", ->
    beforeEach ->
      @event = new CPP.Models.Event @attrs

    it "should exhibit title attribute", ->
      expect(@event.get 'title').toEqual @attrs.title

    it "should exhibit description attribute", ->
      expect(@event.get 'description').toEqual @attrs.description

    it "should exhibit location attribute", ->
      expect(@event.get 'location').toEqual @attrs.location

    it "should exhibit start_date attribute", ->
      expect(@event.get 'start_date').toEqual @attrs.start_date

    it "should exhibit end_date attribute", ->
      expect(@event.get 'end_date').toEqual @attrs.end_date

  describe "when saving required fields", ->
    beforeEach ->
      spy = @errorSpy = sinon.spy()
      init = CPP.Models.Event::initialize
      CPP.Models.Event::initialize = ->
        spy(@, "validated:invalid")
        init.call this

      @event = new CPP.Models.Event @attrs

    afterEach ->
      expect(@errorSpy).toHaveBeenCalledOnce()

    it "should not save when title is empty", ->
      @event.save 'title': ""

    it "should not save when start_date is empty", ->
      @event.save 'start_date': ""

    it "should not save when end_date is empty", ->
      @event.save 'end_date': ""

    it "should not save when description is empty", ->
      @event.save 'description': ""

    it "should not save when location is empty", ->
      @event.save 'location': ""


  describe "when saving optional fields", ->
    beforeEach ->
      successSpy = @successSpy = sinon.spy()
      errorSpy = @errorSpy = sinon.spy()
      init = CPP.Models.Event::initialize
      CPP.Models.Event::initialize = ->
        successSpy(@, "validated:valid")
        errorSpy(@, "validated:invalid")
        init.call this

      @event = new CPP.Models.Event @attrs

    describe "for valid fields", ->
      afterEach ->
        expect(@successSpy).toHaveBeenCalledOnce()

      it "should save when deadline is empty", ->
        @event.save 'deadline': ""

      it "should save when capacity is empty", ->
        @event.save 'capacity': ""

      it "should save when google_map_url is empty", ->
        @event.save 'google_map_url': ""

      # TODO investigate getting Faker.js as a gem?
      it "should allow a valid url for google_map_url", ->
        @event.save 'google_map_url' : 'https://www.google.co.uk'

    describe "for invalid fields", ->
      it "should not allow an invalid url for google_map_url", ->
        @event.save 'google_map_url' : "url"
        @expect(@errorSpy).toHaveBeenCalledOnce()

