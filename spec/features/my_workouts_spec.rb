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

    context "when there are exercises" do
      it "provides a workout analysis" do
        workout = create :workout, :with_exercises, user: user
        workout_date_formatted = workout.date.strftime("%Y-%m-%d")

        evaluation_stub_text = "This workout targeted the abs and legs."

        expect(GeminiAssistant).to receive(:evaluate_workout).with(workout.id) { evaluation_stub_text }

        visit my_workouts_path

        expect(page).to have_button workout_date_formatted
        click_button workout_date_formatted

        expect(page).to have_button "Toggle Workout Analysis"
        click_button "Toggle Workout Analysis"

        expect(page).to have_link "Generate Workout Analysis"
        click_link "Generate Workout Analysis"

        expect(page).to have_content evaluation_stub_text
      end
    end

    context "when there are not exercises" do
      it "the workout cannot be analyzed" do
        workout = create :workout, user: user
        workout_date_formatted = workout.date.strftime("%Y-%m-%d")

        evaluation_stub_text = "Please add exercises to this workout before evaluating it."

        expect(GeminiAssistant).to receive(:evaluate_workout).with(workout.id) { evaluation_stub_text }

        visit my_workouts_path

        expect(page).to have_button workout_date_formatted
        click_button workout_date_formatted

        expect(page).to have_button "Toggle Workout Analysis"
        click_button "Toggle Workout Analysis"

        expect(page).to have_link "Generate Workout Analysis"
        click_link "Generate Workout Analysis"

        expect(page).to have_content evaluation_stub_text
      end
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

    it "evaluates the exercise" do
      workout = create :workout, user: user
      exercise = create :exercise, :with_a_description, workout: workout

      workout_date_formatted = workout.date.strftime("%Y-%m-%d")
      evaluation_stub = "This workout targets the body and can be improved by trying harder."

      expect {
        expect(GeminiAssistant).to receive(:evaluate_exercise).with(exercise) { evaluation_stub }
  
        visit my_workouts_path
  
        expect(page).to have_button workout_date_formatted
        click_button workout_date_formatted
  
        expect(page).to have_button exercise.name
        click_button exercise.name
  
        expect(page).to have_link "Evaluate Exercise" 
        click_link "Evaluate Exercise"
  
        expect(page).to have_content evaluation_stub
      }.to change { exercise.reload.gemini_response }.from(nil).to(evaluation_stub)
    end
  end

  context "exercise sets" do
    it "creates an exercise set for an existing exercise" do
      exercise = create :exercise, :with_a_description

      sign_in exercise.user

      expect {
        visit my_workouts_path
  
        expect(page).to have_button exercise.workout.date.strftime("%Y-%m-%d")
        click_button exercise.workout.date.strftime("%Y-%m-%d")
  
        expect(page).to have_button exercise.name
        click_button exercise.name
  
        expect(page).to have_content exercise.description
  
        reps = 10
        weight = 120
        within("form[action=\"#{workout_exercise_exercise_sets_path(exercise.workout, exercise)}\"") do
          fill_in "exercise_set[reps]", with: reps
          fill_in "exercise_set[weight]", with: weight
        end
  
        click_button "Add Set"
        expect(page).to have_content "Set: #{reps} reps, #{weight.to_f} lbs"
      }.to change { ExerciseSet.count }.from(0).to(1)
    end

    it "allows the user to edit an existing exercise set" do
      exercise = create :exercise, :with_a_description, :with_exercise_sets, exercise_set_traits: [:with_reps, :with_weight]

      sign_in exercise.user

      visit my_workouts_path

      workout_date_formatted = exercise.workout.date.strftime("%Y-%m-%d")
      expect(page).to have_button 
      click_button workout_date_formatted

      expect(page).to have_button exercise.name
      click_button exercise.name

      # Wait for the exercise set index to be on the page, then scroll to it to trigger turbo loads on set info
      expect(page).to have_selector "#exercise_sets_exercise_#{exercise.id}", visible: :all
      scroll_to find("#exercise_sets_exercise_#{exercise.id}", visible: :all)
      
      # With the turbo frame in view, the set info will load into the page
      exercise_set = exercise.exercise_sets.last
      expect(page).to have_content "Set: #{exercise_set.reps} reps, #{exercise_set.weight.to_f} lbs"

      # Open the edit form
      expect(page).to have_link href: edit_workout_exercise_exercise_set_path(exercise.workout, exercise, exercise_set)
      click_link href: edit_workout_exercise_exercise_set_path(exercise.workout, exercise, exercise_set)
      
      expect(page).to have_selector("#info_exercise_set_#{exercise_set.id}")

      reps = 10
      weight = 50.25
      within find("#info_exercise_set_#{exercise_set.id}").find("form") do
        rep_input_name = "exercise_set[reps]"
        weight_input_name = "exercise_set[weight]"

        expect(find("input[name=\"#{rep_input_name}\"").value).to eq exercise_set.reps.to_s
        expect(find("input[name=\"#{weight_input_name}\"").value).to eq exercise_set.weight.to_s

        fill_in rep_input_name, with: reps
        fill_in weight_input_name, with: weight
        
        click_button "Update"
      end

      expect(page).to have_content "Set: #{reps} reps, #{weight.to_f} lbs"
      expect(exercise_set.reload.reps).to eq reps
      expect(exercise_set.reload.weight).to eq weight
    end
  end
end
