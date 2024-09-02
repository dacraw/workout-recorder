require 'rails_helper'

RSpec.describe "Exercises", type: :request do
  let(:user) { create :user }

  describe "GET /index" do
    let(:workout) { create :workout, :with_exercises, user: user }
    
    context "authenticated" do
      before :each do 
        sign_in user
      end

      it "renders all of the exercises within a workout" do
        get workout_exercises_path(workout)

        expect(response).to render_template :index

        workout.exercises.each do |exercise|
          expect(response.body).to include "<turbo-frame id=\"exercises_workout_#{workout.id}\">"
        end
      end
    end

    context "unauthenticated" do
      it "redirects to sign in page" do
        get workout_exercises_path(workout)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST /create" do
    let(:workout) { create :workout, user: user }

    context "authenticated" do
      before :each do 
        sign_in user
      end

      it "requires the current user to be the workout creator" do
        other_workout = create :workout

        post workout_exercises_path(other_workout)

        expect(response).to redirect_to my_workouts_path
        expect(Exercise.count).to eq 0
      end

      context "turbo stream" do
        it "creates a new workout exercise" do
          expect {
            post workout_exercises_path(workout, params: { exercise: { name: "Squats" }}), as: :turbo_stream
  
            expect(response).to render_template :create
          }.to change { Workout.count }.from(0).to(1)
        end
      end
    end
  end 

  describe "PATCH /update" do
    let(:exercise) { create :exercise }

    context "authorized" do

      before :each do
        sign_in exercise.user
      end

      context "turbo stream" do
        it "updates an exercise" do
          exercise_name = "Pullups"

          patch workout_exercise_path(exercise.workout, exercise), params: { exercise: { name: exercise_name } }, as: :turbo_stream

          expect(exercise.reload.name).to eq exercise_name
        end
        it "renders proper template" do
          exercise_name = "Dips"
          
          patch workout_exercise_path(exercise.workout, exercise), params: { exercise: { name: exercise_name }}, as: :turbo_stream

          expect(response).to render_template :update

          expect(response.body).to include "<turbo-stream action=\"replace\" target=\"exercise_#{exercise.id}\">"

          expect(response.body).to include "<turbo-stream action=\"update\" target=\"info_link_exercise_#{exercise.id}\">"

          expect(response.body).to include exercise_name
        end
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:exercise) { create :exercise }

    context "authorized" do
      before :each do
        sign_in exercise.user
      end

      it "destroys an exercise" do
        expect { 
          delete workout_exercise_path(exercise.workout, exercise), as: :turbo_stream
        }.to change {
          Exercise.count
        }.from(1).to(0)
      end

      it "renders the proper template" do
        delete workout_exercise_path(exercise.workout, exercise), as: :turbo_stream

        expect(response).to render_template :destroy
        expect(response.body).to include "<turbo-stream action=\"remove\" target=\"#{workout_exercise_path(exercise.workout, exercise)}\">"
      end
    end
  end
end
