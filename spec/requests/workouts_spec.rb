require 'rails_helper'

RSpec.describe "Workouts", type: :request do
  describe "GET /index" do
    let!(:workout_with_exercises) { create(:workout, :with_exercises) }
    let!(:workout_without_exercises) { create(:workout) }
    
    it "retrieves workouts with exercises" do
      get workouts_path

      expect(response).to render_template :index
    end
  end
end
