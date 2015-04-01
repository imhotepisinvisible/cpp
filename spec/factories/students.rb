# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student, parent: :user, :class => "Student" do
    standard_bio
    first_year
    looking_for {["Not looking for anything", "Looking for a Summer Placement", "Looking for an Industrial Placement"].sample}
    email {["og514", "isb14", "hwl214", "sg5414", "al4209"].sample + "@imperial.ac.uk"}

    trait :first_year do
      year 1
    end

    trait :second_year do
      year 2
    end

    trait :third_year do
      year 3
    end

    trait :fourth_year do
      year 4
    end

    trait :standard_bio do
      bio "I am amazing"
    end
  end
end
