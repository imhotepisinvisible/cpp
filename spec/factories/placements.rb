# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :placement do
    company
    position { ["SDE", "SDET", "Web Development"].sample + " " + ["Intern", "Graduate"].sample}
    description { Faker::Company.bs }
    duration "6 months"
    location { Faker::Address.street_address }
    deadline { FactoryHelper.time_rand }
  end
end
