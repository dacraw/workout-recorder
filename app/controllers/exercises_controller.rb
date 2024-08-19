class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[ show edit update destroy ]
  before_action :set_workout
  before_action :check_author, except: [:index, :show]

  def new
    @exercise = Exercise.new
  end

  def edit
  end

  def create
    @exercise = Exercise.new(exercise_params)
    @exercise.workout_id = params[:workout_id]
    
    respond_to do |format|
      if @exercise.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("exercises_workout_#{@workout.id}", partial: 'exercises/exercise', locals: {workout: @workout, exercise: @exercise}) }
        format.html { redirect_to workout_url(@exercise.workout_id), notice: "Exercise was successfully created." }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@exercise, partial: "exercises/exercise", locals: { exercise: @exercise, workout: @workout}) }
        format.html { redirect_to workout_exercise_url(@workout, @exercise), notice: "Exercise was successfully updated." }
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exercise.destroy!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@exercise)}
      format.html { redirect_to url_for(controller: 'workouts', action: 'my_workouts', params: {workout_id: @workout.id}), notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    def set_workout
      @workout = Workout.find params[:workout_id]
    end

    # Only allow a list of trusted parameters through.
    def exercise_params
      params.require(:exercise).permit(:name, :description, :date)
    end

    def check_author
      @workout ||= Workout.find params[:workout_id]
      redirect_to my_workouts_path params[:id] if current_user != @workout.user
    end
end
