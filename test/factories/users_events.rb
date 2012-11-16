# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :users_event, :class => 'UsersEvents' do
    user nil
    event nil
  end
end
