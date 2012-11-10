# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department do
    association :organisation, factory: :organisation_with_domains
    # organisation
    name "Department of Computing"
  end
end
