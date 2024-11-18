include GeminiAssistant

class ExercisesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_exercise, only: %i[ show edit update destroy ]
  before_action :set_workout
  before_action :check_author, except: [:index, :show]

  def index
    @exercises = @workout.exercises
  end

  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = Exercise.new(exercise_params)
    @exercise.workout_id = params[:workout_id]

    respond_to do |format|
      if @exercise.save
        format.turbo_stream
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
        format.turbo_stream
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
      format.turbo_stream
      format.html { redirect_to url_for(controller: 'workouts', action: 'my_workouts', params: {workout_id: @workout.id}), notice: "Exercise was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def evaluate_exercise
    @exercise = Exercise.find(params[:exercise_id])
    
    response = GeminiAssistant.evaluate_exercise @exercise

    @exercise.gemini_response = response

    respond_to do |format|
      if @exercise.save
        format.turbo_stream 
      else
        format.html { render plain: "Couldn't save the exercise"}
      end
    end
  end

  private
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    def set_workout
      @workout = Workout.find params[:workout_id]
    end

    def exercise_params
      params.require(:exercise).permit(:name, :description, :date)
    end

    def check_author
      @workout ||= Workout.find params[:workout_id]
      redirect_to my_workouts_path if current_user != @workout.user
    end
end
