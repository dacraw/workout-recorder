require 'rails_helper'

RSpec.describe ExerciseSet, type: :model do
  it "requires either reps or weight in order to be created" do
    expect {
      set = build(:exercise_set)
  
      expect(set.save).to be false
      expect(set.errors.full_messages).to include "Either reps or weight must be present."
    }.not_to change { ExerciseSet.count}
  end

  it "creates a set when reps are entered" do
    expect {
      set = build(:exercise_set, reps: 3)
      
      expect(set.save).to be true
    }.to change { ExerciseSet.count }.from(0).to(1)
  end

  it "creates a set when weight is entered" do
    expect {
      set = build(:exercise_set, weight: 120.0)

      expect(set.save).to be true
    }.to change {ExerciseSet.count }.from(0).to(1)
  end
end
