describe "Placement", ->
  describe "when used alone", ->
    beforeEach ->
      @position = "SDE Intern"
      @location = "Barbican, London"
      @description = "Work on Amazon Instant Video"
      @deadline = new Date
      @duration = "3 months"


      @placement = new CPP.Models.Placement {
        position: @position
        location: @location
        description: @description
        deadline: @deadline
        duration: @duration
      }

      console.log @placement

    describe "url", ->
      describe "when no id is set", ->
        it "should return the collection URL", ->
          expect(@placement.url()).toEqual '/placements'

      describe "when id is set", ->
        it "should return the collection URL and id", ->
          @placement.id = 1
          expect(@placement.url()).toEqual '/placements/1'

    describe "when instantiated", ->
      it "should exhibit position attribute", ->
        expect(@placement.get 'position').toEqual @position

      it "should exhibit location attribute", ->
        expect(@placement.get 'location').toEqual @location

      it "should exhibit description attribute", ->
        expect(@placement.get 'description').toEqual @description

      it "should exhibit deadline attribute", ->
        expect(@placement.get 'deadline').toEqual @deadline

      it "should exhibit duration attribute", ->
        expect(@placement.get 'duration').toEqual @duration

  describe "when saving required fields", ->
    beforeEach ->
      spy = @error_spy = sinon.spy();
      init = CPP.Models.Event::initialize
      CPP.Models.Placement::initialize = ->
        spy(@, "validated:invalid")
        init.call this

      @placement = new CPP.Models.Placement {
        title: @title
        description: @description
        location: @location
        start_date: @start_date
        end_date: @end_date
      }

    it "should not save when position is empty", ->
      @placement.save 'position': ""
      expect(@error_spy).toHaveBeenCalledOnce();

    it "should not save when description is empty", ->
      @placement.save 'description': ""
      expect(@error_spy).toHaveBeenCalledOnce();

    it "should not save when description is empty", ->
      @placement.save 'location': ""
      expect(@error_spy).toHaveBeenCalledOnce();

  describe "when saving optional fields", ->
    beforeEach ->
      spy = @success_spy = sinon.spy();
      init = CPP.Models.Event::initialize
      CPP.Models.Placement::initialize = ->
        spy(@, "validated:valid")
        init.call this

      @placement = new CPP.Models.Placement {
        title: @title
        description: @description
        location: @location
        start_date: @start_date
        end_date: @end_date
      }

    it "should save when deadline is empty", ->
      @placement.save 'deadline': ""
      expect(@success_spy).toHaveBeenCalledOnce();

    it "should save when duration is empty", ->
      @placement.save 'duration': ""
      expect(@success_spy).toHaveBeenCalledOnce();

