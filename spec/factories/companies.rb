FactoryGirl.define do
  factory :company do
    name Faker::Company.name
    logo "some_random_image.jpg"
    description Faker::Company.bs
  end
end
