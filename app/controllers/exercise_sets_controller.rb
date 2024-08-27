class ExerciseSetsController < ApplicationController
    before_action :set_exercise
    before_action :set_workout
    
    def index
        @exercise_sets = @exercise.exercise_sets
    end
    
    def create
        respond_to do |format|
            format.turbo_stream
        end
    end

    private

    def exercise_set_params
        params.require(:exercise_set).permit(:reps, :weight, :weight_unit, :description)
    end

    def set_exercise
        @exercise = Exercise.find_by_id(params[:exercise_id])

        # add handler for blank exercise (redirect to new path)
    end

    def set_workout
        @workout = Workout.find_by_id(params[:workout_id])

        # add handler for blank exercise (redirect to new path)
    end

end
