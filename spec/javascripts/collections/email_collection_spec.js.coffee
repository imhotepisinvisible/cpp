describe "Tagged Email collection", ->
  emails = new CPP.Collections.TaggedEmails

  it "should exist", ->
    expect(CPP.Collections.TaggedEmails).toBeDefined()

  it "should use the TaggedEmails model", ->
    expect(emails.model).toEqual CPP.Models.TaggedEmail
    