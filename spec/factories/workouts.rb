FactoryBot.define do
  factory :workout do
    user

    trait :with_exercises do
      after :create do |workout|
        workout.exercises = create_list(:exercise, 2, workout: workout)
        workout.save
      end
    end
  end
end
