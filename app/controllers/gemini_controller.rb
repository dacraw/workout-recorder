class GeminiController < ApplicationController
    before_action :authenticate_user!

    def tag_selector
    end

    def suggest_exercises
        response = GeminiAssistant.suggest_exercise_based_on_type(params[:prompt])
        @selected_tags = params[:prompt]
        
        rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, hard_wrap: true)
        @html_response = rc.render response
    end

    def suggest_workout
        response = GeminiAssistant.suggest_workout_based_on_type(params[:prompt])
        @selected_tags = params[:prompt]
        
        rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, hard_wrap: true)
        @html_response = rc.render response
    end
end
