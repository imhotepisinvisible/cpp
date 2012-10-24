# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :placement do
    company
    position "SDE INTERN"
    description { Faker::Company.bs }
    duration "6 months"
    location { Faker::Address.street_address }
    deadline { FactoryHelper.time_rand }
  end
end
