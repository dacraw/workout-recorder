class ExerciseSetsController < ApplicationController
    before_action :set_exercise
    before_action :set_workout
    
    def index
        @exercise_sets = @exercise.exercise_sets
    end
    
    def create
        @exercise_set = @exercise.exercise_sets.new(exercise_set_params)

        if @exercise_set.save
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.prepend(workout_exercise_exercise_sets_path(@workout, @exercise), partial: "exercise_sets/exercise_set", locals: { set: @exercise_set }) }
            end
            # add an else that redirects if save fails
        end
    end

    def new

    end

    private

    def exercise_set_params
        params.require(:exercise_set).permit(:reps, :weight, :weight_unit)
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
