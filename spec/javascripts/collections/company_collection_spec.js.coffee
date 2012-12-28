describe "Company collection", ->
  companies = new CPP.Collections.Companies

  it "should exist", ->
    expect(CPP.Collections.Companies).toBeDefined()
    
  it "should use the companies model", ->
    expect(companies.model).toEqual CPP.Models.Company