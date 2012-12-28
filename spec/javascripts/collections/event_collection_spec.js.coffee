describe "Tagged Email collection", ->
  events = new CPP.Collections.Events

  it "should exist", ->
    expect(CPP.Collections.Events).toBeDefined()

  it "should use the Events model", ->
    expect(events.model).toEqual CPP.Models.Event
    