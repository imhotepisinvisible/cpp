describe "Tests for the Courses Model", ->

  attrs = 
    id: 1
    name: "Computing"

  course = new CPP.Models.Course attrs

  it "should exist", ->
    expect(course).toBeDefined()

  it "should contain the id 1", ->
    expect(course.attributes.id).toEqual(1)

  it "should have the name 'Computing'", ->
    expect(course.attributes.name).toEqual("Computing")

	