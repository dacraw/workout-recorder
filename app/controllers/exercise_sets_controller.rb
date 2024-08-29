class ExerciseSetsController < ApplicationController
    before_action :authenticate_user!, except: %i[index]
    before_action :set_exercise
    before_action :set_workout
    before_action :set_exercise_set, only: %i[destroy edit update]
    before_action :check_author, except: [:index]
    
    
    def index
        @exercise_sets = @exercise.exercise_sets
    end
    
    def create
        @exercise_set = @exercise.exercise_sets.new(exercise_set_params)
        respond_to do |format|
            if @exercise_set.save
                format.turbo_stream
            else
                format.html { render :new, status: :unprocessable_entity }
            end
        end
    end

    def new
        @exercise_set = @exercise.exercise_sets.new
    end

    def destroy
        @exercise_set.destroy

        respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.remove(@exercise_set)}
        end
    end

    def update
        respond_to do |format|
            if @exercise_set.update(exercise_set_params)
                format.turbo_stream
            else
                format.html { render :edit, status: :unprocessable_entity }
            end
        end
    end

    private

    def exercise_set_params
        params.require(:exercise_set).permit(:reps, :weight, :weight_unit)
    end

    def set_exercise
        @exercise = Exercise.find_by_id(params[:exercise_id])

        if @exercise.blank?
            flash[:alert] = "That exercise doesn't exist."
            return redirect_to my_workouts_path
        end 
    end

    def set_workout
        @workout = Workout.find_by_id(params[:workout_id])

        if @workout.blank?
            flash[:alert] = "That workout doesn't exist."
            return redirect_to my_workouts_path
        end 
    end

    def set_exercise_set
        @exercise_set = ExerciseSet.find_by_id(params[:id])

        if @exercise_set.blank?
            flash[:alert] = "That exercise set doesn't exist."
            return redirect_to my_workouts_path
        end 
    end

    def check_author
        @workout ||= Workout.find params[:workout_id]

        redirect_to my_workouts_path if current_user != @workout.user
    end
end
