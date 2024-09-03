require 'rails_helper'

RSpec.describe "ExerciseSets", type: :request do
  let(:exercise_set) { create :exercise_set, reps: 5, weight: 30.0 }

  describe "GET /index" do
    it "renders exercise sets for its associated exercise" do
      get workout_exercise_exercise_sets_path(exercise_set.workout, exercise_set.exercise)

      expect(response.status).to eq 200
      expect(response.body).to include "#{exercise_set.reps} reps, #{exercise_set.weight} lbs"

      expect(request.params[:workout_id].to_i).to eq exercise_set.workout.id
      expect(request.params[:exercise_id].to_i).to eq exercise_set.exercise.id
    end
  end

  describe "POST /create" do
    let(:exercise) { create :exercise }
    let(:exercise_set) { build :exercise_set, exercise: exercise }

    context "authenticated" do
      before :each do
        sign_in exercise.user
      end

      it "requires the current user to be the same as the workout creator" do
        other_exercise = create :exercise

        expect {
          post workout_exercise_exercise_sets_path(other_exercise.workout, other_exercise), params: { exercise_set: { reps: 10 }}, as: :turbo_stream

          expect(response).to redirect_to my_workouts_path
        }.not_to change {ExerciseSet.count}
      end

      context "turbo stream" do
        it "creates an exercise set" do
          reps = 15

          expect {
            post workout_exercise_exercise_sets_path(exercise_set.workout, exercise_set.exercise), params: { exercise_set: { reps: reps }}, as: :turbo_stream

            expect(ExerciseSet.last.reps).to eq reps
          }.to change { ExerciseSet.count }.from(0).to(1)
        end
      end
    end

    context "unauthenticated" do
      it "redirects to the sign in page" do
        post workout_exercise_exercise_sets_path(exercise_set.workout, exercise_set.exercise), params: { exercise: { reps: 15 }}

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
