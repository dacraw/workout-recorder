class WorkoutsController < ApplicationController
    before_action :authenticate_user!

    def new
        @workout = Workout.new
    end

    def create
        @workout = Workout.new
        @workout.user = current_user

        if @workout.save
            flash[:notice] = "Workout created!"
            redirect_to workout_path @workout
        else
            flash[:alert] = "Workout failed to create!"
            redirect_to my_workouts
        end
    end

    def show
        @workout = Workout.find params[:id]
        @exercises = @workout.exercises
    end

    def my_workouts
        @workouts = current_user.workouts
    end
end
