FactoryBot.define do
  factory :exercise_set do
    weight_unit { "lbs" }
    exercise 
  end

  trait :with_reps do
    reps { Faker::Number.number(digits:2) }
  end

  trait :with_weight do
    weight { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
