describe "Tagged Email collection", ->
  placements = new CPP.Collections.Placements

  it "should exist", ->
    expect(CPP.Collections.Placements).toBeDefined()

  it "should use the Placements model", ->
    expect(placements.model).toEqual CPP.Models.Placement
    