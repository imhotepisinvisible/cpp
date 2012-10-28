FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    logo { %w(amazon facebook google 
              ibm intel microsoft netcraft 
              nextjump palantir vmware).sample + "_logo.jpg" }
    description { Faker::Company.bs }
  end
end

