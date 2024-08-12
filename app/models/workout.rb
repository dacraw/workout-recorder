class Workout < ApplicationRecord
    include GeminiAssistant
    
    belongs_to :muscle_group

    # TODO: Only call this is name/description field changes to minimize Google API calls
    before_save :set_gemini_response

    def gemini_response_html
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        markdown.render self.gemini_response
    end

    def get_and_set_gemini_response_html
        response = evaluate_workout_name_and_description self.name, self.description
        self.update_column :gemini_response, response

        gemini_response_html
        
    def get_and_set_gemini_response
        response = evaluate_workout_name_and_description self.name, self.description
        self.update_column :gemini_response, response

        response
    end

    private

    def set_gemini_response
        self.gemini_response = evaluate_workout_name_and_description self.name, self.description
    end
end
