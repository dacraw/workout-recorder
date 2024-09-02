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
end
