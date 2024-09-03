require 'rails_helper'

RSpec.feature "MyWorkouts", type: :feature, js: true do
  let!(:user) { create :user }
  let!(:workouts) {[
    create(:workout, user: user, date: Time.now),
    create(:workout, user: user, date: 1.days.from_now)
  ]}

  before :each do
    sign_in user
  end

  it "expands into workout information when clicked" do
    visit my_workouts_path

    workout = workouts.first

    find_all(:button, text: workout.date.strftime("%Y-%m-%d")).first.click

    # debugger

    expect(page).to have_css("#exercises_workout_#{workout.id}[complete]", visible: false)
  end
end
