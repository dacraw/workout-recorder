FactoryBot.define do
  factory :workout do
    user

    trait :with_exercises do
      transient do
        exercise_traits { [] }
      end

      after :create do |workout, evaluator|
        workout.exercises = create_list(:exercise, 2, *evaluator.exercise_traits, workout: workout)
        workout.save
      end
    end
  end
end
