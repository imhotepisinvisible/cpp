describe "Event", ->
  # TODO, not sure if this is the best message...
  describe "when used alone", ->
    beforeEach ->
      @title = "Google interview techniques"
      @description = "Ace our interviews"
      @location = "Victoria, London"
      @start_date = new Date
      @end_date = new Date
      @end_date.setDate(@start_date.getDate + 1)


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

  describe "when used in form", ->

    form = new Backbone.Form(model: new CPP.Models.Event).render()
    errors = form.validate()
    console.log errors

    describe "when saving required fields", ->
      it "should not save when title is empty", ->
        expect(errors.hasOwnProperty 'title').toBeTruthy()

      it "should not save when start_date is empty", ->
        expect(errors.hasOwnProperty 'start_date').toBeTruthy()

      it "should not save when end_date is empty", ->
        expect(errors.hasOwnProperty 'end_date').toBeTruthy()

      it "should not save when description is empty", ->
        expect(errors.hasOwnProperty 'description').toBeTruthy()

      it "should not save when location is empty", ->
        expect(errors.hasOwnProperty 'location').toBeTruthy()


    describe "when saving optional fields", ->
      it "should save when deadline is empty", ->
        expect(errors.hasOwnProperty 'deadline').toBeFalsy()

      it "should save when capacity is empty", ->
        expect(errors.hasOwnProperty 'capacity').toBeFalsy()

      it "should save when google_map_url is empty", ->
        expect(errors.hasOwnProperty 'google_map_url').toBeFalsy()
