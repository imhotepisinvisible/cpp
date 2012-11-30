class CPP.Collections.Companies extends CPP.Collections.Base
  url: '/companies'
  model: CPP.Models.Company
  comparator: (company) ->
    return company.get "rating"