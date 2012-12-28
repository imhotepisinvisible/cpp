# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    company
    title { Faker::Company.bs }
    start_date { FactoryHelper.time_rand }
    end_date { FactoryHelper.time_rand(start_date, start_date + 2.day.to_i) }
    deadline { FactoryHelper.time_rand(Time.now, start_date) }
    description { 50.times.map{|i| Faker::Company.bs }.join ' ' }
    location { Faker::Address.street_address }
    capacity { Random.rand(100) }
    google_map_url { Faker::Internet.url }
  end
end

