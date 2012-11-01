describe "Event", ->
  beforeEach ->
    @title = "Google interview techniques"
    @description = "Ace our interviews"
    @location = "Victoria, London"
    @start_date = new Date()
    @end_date = new Date()
    @end_date.setDate(@start_date.getDate() + 1)


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
        expect(@event.url()).toEqual("/events")

    describe "when id is set", ->
      it "should return the collection URL and id", ->
        @event.id = 1
        expect(@event.url()).toEqual("/events/1")

  describe "when instantiated", ->
    it "should exhibit title attribute", ->
      expect(@event.get("title")).toEqual @title

    it "should exhibit description attribute", ->
      expect(@event.get("description")).toEqual @description

    it "should exhibit location attribute", ->
      expect(@event.get("location")).toEqual @location

    it "should exhibit start_date attribute", ->
      expect(@event.get("start_date")).toEqual @start_date

    it "should exhibit end_date attribute", ->
      expect(@event.get("end_date")).toEqual @end_date
