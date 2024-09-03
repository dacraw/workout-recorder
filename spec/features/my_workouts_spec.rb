require 'rails_helper'

RSpec.feature "MyWorkouts", type: :feature, js: true do
  let!(:user) { create :user }

  before :each do
    sign_in user
  end

  context "workouts" do
    it "expands into workout information when clicked" do
      workouts = [
        create(:workout, user: user, date: Time.now),
        create(:workout, user: user, date: 1.days.from_now)
      ]
  
      visit my_workouts_path
  
      workout = workouts.first
  
      find_all(:button, text: workout.date.strftime("%Y-%m-%d")).first.click
  
      expect(page).to have_css("#exercises_workout_#{workout.id}[complete]", visible: false)
    end

    it "allows a user to create a workout" do
      expect { 
        visit my_workouts_path
  
        expect(page).to have_content "My Workouts"
        click_button "Create New Workout"
        expect(page).to have_content "Workout created!"
      }.to change { Workout.count }.from(0).to(1)
    end

    it "allows a user to receive a suggested exercise" do
      suggested_exercise_stub = "Romanian Deadlift - 3 sets x 10-12 reps"
      allow(GeminiAssistant).to receive(:suggest_exercise_based_on_type) { suggested_exercise_stub }
      
      workout = create :workout, user: user
      workout_date_formatted = workout.date.strftime("%Y-%m-%d")

      visit my_workouts_path

      expect(page).to have_content "My Workouts"
      expect(page).to have_button workout_date_formatted

      # Expand workout
      click_button workout_date_formatted

      muscle_groups = ["Calves", "Hamstrings"]

      # Ensure desired tags and exercise suggestion buttons are visible
      muscle_groups.each {|name_str| expect(page).to have_button name_str }
      expect(page).to have_button "Suggest Exercise"

      # Click each tag button then receive exercise suggestion
      muscle_groups.each {|name_str| click_button name_str}
      click_button "Suggest Exercise"

      expect(page).to have_content suggested_exercise_stub
      expect(page).to have_content "Selected Muscle Groups: #{muscle_groups.join(',')}"

      # Close the modal that contains the suggestion
      click_button "Close"

      expect(page).not_to have_content suggested_exercise_stub
      expect(page).not_to have_content "Selected Muscle Groups: #{muscle_groups.join(',')}"
    end
  end

  context "exercises" do
    it "allows a user to create a new exercise for an existing workout" do
      exercise_description = "Child's pose, downward dog, bicycle crunches"
      exercise_name = "Yoga"
      workout = create :workout, user: user
      workout_date_formatted = workout.date.strftime("%Y-%m-%d")

      expect {
        visit my_workouts_path
  
        expect(page).to have_content "My Workouts"

        # Expand the workout
        expect(page).to have_button workout_date_formatted     
        click_button workout_date_formatted
        
        expect(page).to have_button "Create Exercise"
        
        within("form[action=\"#{workout_exercises_path(workout)}\"]") do
          fill_in "exercise[name]", with: exercise_name
          fill_in "exercise[description]", with: exercise_description
        end
  
        click_button "Create Exercise"

        expect(page).to have_button exercise_name
      }.to change { Exercise.count }.from(0).to(1)

      exercise = Exercise.last
      expect(exercise.name).to eq exercise_name
      expect(exercise.description).to eq exercise_description
      expect(exercise.user).to eq user
    end

    it "expands when clicked" do
      workout = create :workout, :with_exercises, user: user, exercise_traits: [:with_a_description]
      workout_date_formatted = workout.date.strftime("%Y-%m-%d")
      exercises = workout.exercises

      visit my_workouts_path

      expect(page).to have_button workout_date_formatted
      click_button workout_date_formatted

      exercises.each do |exercise|
        expect(page).to have_button exercise.name
      end

      click_button exercises.first.name
      expect(page).to have_content exercises.first.description
    end
  end
end
