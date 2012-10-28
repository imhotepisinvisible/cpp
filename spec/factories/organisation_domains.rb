FactoryGirl.define do
  factory :organisation_domain do
    organisation
    domain { ["ic.ac.uk", "imperial.ac.uk"].sample }
  end
end
