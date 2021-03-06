FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    description { 80.times.map{ Faker::Lorem.words(1) }.join(" ").truncate(80) }
  end
end

