describe "Event", ->
  beforeEach ->
    @title = "Google interview techniques"
    @description = "Ace our interviews"
    @location = "Victoria, London"
    @start_date = new Date
    @end_date = new Date

  describe "Not sure", ->
    # TODO, not sure if this is the best message...
    beforeEach ->
      @event = new CPP.Models.Event {
        title: @title
        description: @description
        location: @location
        start_date: @start_date
        end_date: @end_date
      }

    describe "url", ->
      describe "when no id is set", ->
        it "should return the collection URL", ->
          expect(@event.url()).toEqual '/events'

      describe "when id is set", ->
        it "should return the collection URL and id", ->
          @event.id = 1
          expect(@event.url()).toEqual '/events/1'

    describe "when instantiated", ->
      it "should exhibit title attribute", ->
        expect(@event.get 'title').toEqual @title

      it "should exhibit description attribute", ->
        expect(@event.get 'description').toEqual @description

      it "should exhibit location attribute", ->
        expect(@event.get 'location').toEqual @location

      it "should exhibit start_date attribute", ->
        expect(@event.get 'start_date').toEqual @start_date

      it "should exhibit end_date attribute", ->
        expect(@event.get 'end_date').toEqual @end_date

  describe "when saving required fields", ->
    beforeEach ->
      spy = @error_spy = sinon.spy();
      init = CPP.Models.Event::initialize
      CPP.Models.Event::initialize = ->
        spy(@, "validated:invalid")
        init.call this

      @event = new CPP.Models.Event {
        title: @title
        description: @description
        location: @location
        start_date: @start_date
        end_date: @end_date
      }

    it "should not save when title is empty", ->
      @event.save 'title': ""
      console.log @error_spy
      expect(@error_spy).toHaveBeenCalledOnce();

    it "should not save when start_date is empty", ->
      @event.save 'start_date': null
      expect(@error_spy).toHaveBeenCalledOnce();

    it "should not save when end_date is empty", ->
      @event.save 'end_date': null
      expect(@error_spy).toHaveBeenCalledOnce();

    it "should not save when description is empty", ->
      @event.save 'description': null
      expect(@error_spy).toHaveBeenCalledOnce();

    it "should not save when location is empty", ->
      @event.save 'location': null
      expect(@error_spy).toHaveBeenCalledOnce();


  describe "when saving optional fields", ->
    beforeEach ->
      spy = @success_spy = sinon.spy();
      init = CPP.Models.Event::initialize
      CPP.Models.Event::initialize = ->
        spy(@, "validated:valid")
        init.call this

      @event = new CPP.Models.Event {
        title: @title
        description: @description
        location: @location
        start_date: @start_date
        end_date: @end_date
      }


    it "should save when deadline is empty", ->
      @event.save 'deadline': null
      expect(@success_spy).toHaveBeenCalledOnce();

    it "should save when capacity is empty", ->
      @event.save 'capacity': null
      expect(@success_spy).toHaveBeenCalledOnce();

    it "should save when google_map_url is empty", ->
      @event.save 'google_map_url': null
      expect(@success_spy).toHaveBeenCalledOnce();

