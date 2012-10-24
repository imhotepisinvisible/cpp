# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student, parent: :user do
    type "Student"
  end
end
