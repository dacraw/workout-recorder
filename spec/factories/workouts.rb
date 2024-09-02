FactoryBot.define do
  factory :workout do
    
    before :create do |workout|
      if workout.user.nil?
        workout.user = create(:user)
        workout.save

        workout.reload
      end
    end

    trait :with_exercises do
      before :create do |workout|
        workout.exercises = create_list(:exercise, 2, user: workout.user)
        workout.save

        workout.reload
      end
    end
  end
end
