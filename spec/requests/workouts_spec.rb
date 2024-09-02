require 'rails_helper'

RSpec.describe "Workouts", type: :request do
  describe "GET /index" do
    let!(:workout_with_exercises) { create(:workout, :with_exercises) }
    let!(:workout_without_exercises) { create(:workout) }
    
    it "retrieves workouts with exercises" do
      get workouts_path

      expect(response).to render_template :index
      expect(response.body).to include("User " + workout_with_exercises.user.id.to_s)
      expect(response.body).not_to include("User " + workout_without_exercises.user.id.to_s)
    end
  end

  describe "POST /create" do
    let(:user) { create :user }

    before :each do
      sign_in user
    end

    it "creates a new workout" do
      expect {
        post workouts_path
      }.to change { Workout.count }.by 1
    end

    it "redirects to the My Workouts page with the new workout's id as a param" do
      post workouts_path

      expect(response).to redirect_to url_for(controller: 'workouts', action: 'my_workouts', params: {workout_id: Workout.last.id})    

      follow_redirect!
      expect(response.body).to include '<h1 class="page-header">My Workouts</h1>'
    end
  end

  describe "GET /show" do
    let(:user) { create :user }
    let(:workout) { create(:workout, :with_exercises, user: user) }

    before :each do
      sign_in user
    end
    
    it "renders the show page for the workout" do
      get workout_path(workout)
      expect(response).to render_template :show
      expect(response.body).to include("exercises_workout_" + workout.id.to_s) # turbo frame id
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user) }
    let!(:workout) { create(:workout, user: user) }

    before :each do
      sign_in user
    end
    
    it "destroys an existing workout" do
      expect { delete workout_path(workout) }
      .to change { Workout.count }.from(1).to(0)
    end

    it "redirects to My Workouts page" do
      delete workout_path(workout)

      expect(response.status).to eq 302
      expect(response).to redirect_to my_workouts_path
    end
  end
end
