# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student, parent: :user, :class => "Student" do
    department
    standard_bio
    beng_student
    first_year

    factory :student_with_profile do
      association :profile, factory: :student_profile
    end

    trait :beng_student do
      degree "BEng"
    end

    trait :meng_student do
      degree "MEng"
    end

    trait :msc_student do
      degree "Msc"
    end

    trait :phd_student do
      degree "PhD"
    end

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
