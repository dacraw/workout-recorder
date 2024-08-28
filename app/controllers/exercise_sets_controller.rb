class ExerciseSetsController < ApplicationController
    before_action :set_exercise
    before_action :set_workout
    before_action :set_exercise_set, only: %i[destroy edit update]
    
    def index
        @exercise_sets = @exercise.exercise_sets
    end
    
    def create
        @exercise_set = @exercise.exercise_sets.new(exercise_set_params)

        if @exercise_set.save
            respond_to do |format|
                format.turbo_stream { render turbo_stream: turbo_stream.prepend(workout_exercise_exercise_sets_path(@workout, @exercise), partial: "exercise_sets/exercise_set", locals: { workout: @workout, exercise: @exercise, exercise_set: @exercise_set }) }
            end
            # add an else that redirects if save fails
        end
    end

    def new

    end

    def destroy
        @exercise_set.destroy

        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.remove(workout_exercise_exercise_set_path(@workout, @exercise, @exercise_set))}
        end
    end

    def edit

    end

    def update
        respond_to do |format|
            if @exercise_set.update(exercise_set_params)
                format.turbo_stream { render turbo_stream: turbo_stream.replace(@exercise_set, partial: "exercise_sets/exercise_set", locals: { workout: @workout, exercise: @exercise, exercise_set: @exercise_set}) }
            end
        end
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

    def set_exercise_set
        @exercise_set = ExerciseSet.find(params[:id])
    end

end
