describe "Placement", ->
  beforeEach ->
    @attrs = 
      position: "SDE Intern"
      location: "Barbican, London"
      description: "Work on Amazon Instant Video"
      deadline: new Date
      duration: "3 months"


    @placement = new CPP.Models.Placement @attrs

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
      expect(@placement.get 'position').toEqual @attrs.position

    it "should exhibit location attribute", ->
      expect(@placement.get 'location').toEqual @attrs.location

    it "should exhibit description attribute", ->
      expect(@placement.get 'description').toEqual @attrs.description

    it "should exhibit deadline attribute", ->
      expect(@placement.get 'deadline').toEqual @attrs.deadline

    it "should exhibit duration attribute", ->
      expect(@placement.get 'duration').toEqual @attrs.duration

describe "when saving required fields", ->
  beforeEach ->
    spy = @error_spy = sinon.spy();
    init = CPP.Models.Event::initialize
    CPP.Models.Placement::initialize = ->
      spy(@, "validated:invalid")
      init.call this

    @placement = new CPP.Models.Placement @attrs

  afterEach ->
    expect(@error_spy).toHaveBeenCalledOnce()

  it "should not save when position is empty", ->
    @placement.save 'position': ""

  it "should not save when description is empty", ->
    @placement.save 'description': ""

  it "should not save when description is empty", ->
    @placement.save 'location': ""

describe "when saving optional fields", ->
  beforeEach ->
    spy = @success_spy = sinon.spy();
    init = CPP.Models.Event::initialize
    CPP.Models.Placement::initialize = ->
      spy(@, "validated:valid")
      init.call this

    @placement = new CPP.Models.Placement @attrs

  afterEach ->
    expect(@success_spy).toHaveBeenCalledOnce()

  it "should save when deadline is empty", ->
    @placement.save 'deadline': ""

  it "should save when duration is empty", ->
    @placement.save 'duration': ""

  it "should save when open_to is empty", ->
    @placement.save 'open_to': ""

  it "should save when salary is empty", ->
    @placement.save 'salary': ""

  it "should save when benefits is empty", ->
    @placement.save 'benefits': ""

  it "should save when application_procedure is empty", ->
    @placement.save 'application_procedure': ""

  it "should save when interview_date is empty", ->
    @placement.save 'interview_date': ""

  it "should save when other is empty", ->
    @placement.save 'other': ""

