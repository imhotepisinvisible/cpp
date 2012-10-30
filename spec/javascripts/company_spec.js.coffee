describe "Company", ->
  it "should expose an attribute", ->
    company = new CPP.Models.Company {
      name: "Google"
    }
    expect(company.get("name")).toEqual "Google"


