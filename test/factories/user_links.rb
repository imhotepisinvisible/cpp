# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_link do
    gitHub "MyString"
    linkedIn "MyString"
    personal "MyString"
    other "MyString"
  end
end
