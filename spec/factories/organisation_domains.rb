FactoryGirl.define do
  factory :organisation_domain do
    domain { ["ic.ac.uk", "imperial.ac.uk"].sample }
  end
end
