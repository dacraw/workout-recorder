FactoryBot.define do
  factory :exercise do
    name { Faker::Lorem.word }
    workout

    trait :with_a_description do
      description { Faker::Lorem.sentence }
    end

    trait :with_exercise_sets do 
      transient do
        exercise_set_traits { [] }
      end

      after :create do |exercise, evaluator|
        exercise.exercise_sets = create_list :exercise_set, 3, *evaluator.exercise_set_traits, exercise: exercise
      end
    end
  end
end
