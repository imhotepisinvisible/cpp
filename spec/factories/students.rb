# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student, parent: :user, :class => "Student" do
    association :profile, factory: :student_profile
  end
end
