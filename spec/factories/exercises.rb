FactoryBot.define do
  factory :exercise do
    name { Faker::Lorem.word }
    workout
  end
end
