# Read about factories at https://github.com/thoughtbot/factory_girl
module FactoryHelpers

  # Creates a random time between start and finish
  def self.time_rand start = Time.now, finish = Time.now + 20.day.to_i
    Time.at(start.to_i + Random.rand(finish.to_i - start.to_i))
  end
end

FactoryGirl.define do
  factory :event do
    company
    title Faker::Company.bs
    start_date FactoryHelpers.time_rand
    end_date { FactoryHelpers.time_rand(start_date, start_date + 2.day.to_i) }
    deadline { FactoryHelpers.time_rand(Time.now, start_date) }
    description Faker::Company.bs
    location Faker::Address.street_address
    capacity Random.rand(100)
    google_map_url Faker::Internet.http_url
  end
end

