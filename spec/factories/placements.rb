# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :placement do
    company
    position { ["SDE", "SDET", "Web Dev"].sample + " " + ["Intern", "Graduate"].sample}
    description { Faker::Company.bs }
    duration "6 months"
    location { Faker::Address.street_address }
    deadline { FactoryHelper.time_rand }

    salary { ['30000 pa', '2000 a month', '8.50 an hour'].sample }
    benefits { ["None", "Free transport", "Free gym"].sample }
    application_procedure { ["CV & Coverletter", "assessment day"].sample }

  end
end
