# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :department do
    organisation
    name "Department of Computing"
  end
end
