include GeminiAssistant

class WorkoutsController < ApplicationController
    before_action :authenticate_user!, except: %i[ index ]
    before_action :set_workout, only: %i[ show destroy evaluate_workout suggest_exercise_based_on_type suggest_workout_based_on_type ]
    before_action :check_author, only: %i[destroy evaluate_workout suggest_exercise_based_on_type suggest_workout_based_on_type]

    def index
        # Select Workouts that have exercises in them
        @pagy, @workouts = pagy(Workout.includes(:user, :exercises).where.not(exercises: { id: nil }).distinct)
    end

    def create
        @workout = Workout.new
        @workout.user = current_user

        if @workout.save
            flash[:notice] = "Workout created!"
            redirect_to url_for(controller: 'workouts', action: 'my_workouts', params: {workout_id: @workout.id})
        else
            flash[:alert] = "Workout failed to create!"
            redirect_to my_workouts
        end
    end

    def show
        @exercises = @workout.exercises.order(created_at: :desc)
    end

    def destroy
        @workout.destroy!
    
        respond_to do |format|
          format.html { redirect_to my_workouts_path, notice: "Workout was successfully destroyed." }
          format.json { head :no_content }
        end
    end

    def my_workouts
        @workouts = current_user.workouts
    end

    def evaluate_workout
        @workout.update(gemini_response: GeminiAssistant.evaluate_workout(@workout.id))
    end

    def suggest_exercise_based_on_type
        response = GeminiAssistant.suggest_exercise_based_on_type(params[:prompt], @workout.exercises.map {|exercise| "name: #{exercise.name}, description: #{exercise.description}"}.join(';'))

        @selected_tags = params[:prompt]

        rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        @html_response = rc.render response
    end

    def suggest_workout_based_on_type
        response = GeminiAssistant.suggest_workout_based_on_type(params[:prompt], @workout.exercises.map {|exercise| "name: #{exercise.name}, description: #{exercise.description}"}.join(';'))
        @selected_tags = params[:prompt]
        
        rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, hard_wrap: true)
        @html_response = rc.render response
    end

    private
    def set_workout
        @workout ||= Workout.find params[:id]
    end

    def check_author
        @workout ||= Workout.find params[:id]
        redirect_to my_workouts_path if current_user != @workout.user
    end
end
