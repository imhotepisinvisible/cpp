describe "Placement", ->
  beforeEach ->
    @position = "SDE Intern"
    @location = "Barbican, London"
    @description = "Work on Amazon Instant Video"
    @deadline = new Date


    @placement = new CPP.Models.Placement {
      position: @position
      location: @location
      description: @description
      deadline: @deadline
    }

  describe "url", ->
    describe "when no id is set", ->
      it "should return the collection URL", ->
        expect(@placement.url()).toEqual '/placements'

    describe "when id is set", ->
      it "should return the collection URL and id", ->
        @placement.id = 1
        expect(@placement.url()).toEqual '/placements/1'

  describe "validation", ->

    describe "when saving", ->
      beforeEach ->
        @spy = sinon.spy()
        @placement.bind 'error', @spy

      it "should not save when position is empty", ->
        @placement.save({"position": ""})
        expect(@spy.calledOnce).toHaveBeenCalledOnce

    describe "when instantiated", ->
      it "should exhibit position attribute", ->
        expect(@placement.get 'position').toEqual @position

      it "should exhibit location attribute", ->
        expect(@placement.get 'location').toEqual @location

      it "should exhibit description attribute", ->
        expect(@placement.get 'description').toEqual @description

      it "should exhibit deadline attribute", ->
        expect(@placement.get 'deadline').toEqual @deadline

