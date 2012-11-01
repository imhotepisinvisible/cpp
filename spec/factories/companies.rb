FactoryGirl.define do
  factory :company do
    organisation
    name { Faker::Company.name }
    logo { %w(amazon facebook google
              ibm intel microsoft netcraft
              nextjump palantir vmware).sample + "_logo.jpg" }
    description { 80.times.map{ Faker::Lorem.words(1) }.join(" ").truncate(80) }
  end
end

