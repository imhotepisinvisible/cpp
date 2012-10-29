FactoryGirl.define do
  factory :company do
    organisation
    name { Faker::Company.name }
    logo { %w(amazon facebook google
              ibm intel microsoft netcraft
              nextjump palantir vmware).sample + "_logo.jpg" }
    description { Faker::Lorem.characters(80) }
  end
end

