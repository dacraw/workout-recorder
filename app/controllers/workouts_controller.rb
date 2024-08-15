class WorkoutsController < ApplicationController
    before_action :authenticate_user!

    def show
        @workout = Workout.find params[:id]
        @exercises = @workout.exercises
    end

    def my_workouts
        @workouts = current_user.workouts
    end
end
