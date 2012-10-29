# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email do
    company
    subject "Subject"
    body "Body"
  end
end
