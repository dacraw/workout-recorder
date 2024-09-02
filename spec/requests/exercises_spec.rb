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
end
