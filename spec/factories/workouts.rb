FactoryBot.define do
  factory :workout do
    user
    
    before :create do |workout, something|
      if workout.user.nil?
        workout.user = create(:user)
        workout.save
      end
    end

    trait :with_exercises do
      after :create do |workout|
        workout.exercises = create_list(:exercise, 2, workout: workout)
        workout.save
      end
    end
  end
end
