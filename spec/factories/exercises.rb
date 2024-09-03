FactoryBot.define do
  factory :exercise do
    name { Faker::Lorem.word }
    workout

    trait :with_a_description do
      description { Faker::Lorem.sentence }
    end
  end
end
