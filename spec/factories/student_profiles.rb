# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student_profile do
    student_id 1
    year "MyString"
    bio "MyText"
    degree "MyText"
  end
end
