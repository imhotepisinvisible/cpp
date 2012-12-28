describe "Tagged Email collection", ->
  students = new CPP.Collections.Students

  it "should exist", ->
    expect(CPP.Collections.Students).toBeDefined()

  it "should use the Students model", ->
    expect(students.model).toEqual CPP.Models.Student
    