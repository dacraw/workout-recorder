class WorkoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workout, only: %i[ create show ]
    before_action :check_author, except: [:index, :show, :my_workouts]

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
        @exercises = @workout.exercises.order(created_at: :desc)
    end

    def my_workouts
        @workouts = current_user.workouts
    end

    private
    def check_author
        workout = Workout.find params[:workout_id]
        redirect_to exercise_path params[:id] if current_user != workout.user
    end

    def set_workout
        @workout = Workout.find params[:id]
    end
end
