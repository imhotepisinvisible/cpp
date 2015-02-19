# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department do
    organisation {FactoryGirl.create(:organisation_with_domains)}
    name "Department of Computing"

    settings_notifier_placement { Faker::Lorem.sentences(3) }
    settings_notifier_event { Faker::Lorem.sentences(2) }
    
  end
end
