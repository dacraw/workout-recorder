require 'rails_helper'

RSpec.describe "ExerciseSets", type: :request do
  describe "GET /index" do
    let(:exercise_set) { create :exercise_set, reps: 5, weight: 30.0 }
    
    it "renders exercise sets for its associated exercise" do
      get workout_exercise_exercise_sets_path(exercise_set.workout, exercise_set.exercise)

      expect(response.status).to eq 200
      expect(response.body).to include "#{exercise_set.reps} reps, #{exercise_set.weight} lbs"

      expect(request.params[:workout_id].to_i).to eq exercise_set.workout.id
      expect(request.params[:exercise_id].to_i).to eq exercise_set.exercise.id
    end
  end
end
