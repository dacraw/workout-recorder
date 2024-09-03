class Exercise < ApplicationRecord
    include GeminiAssistant

    EXERCISE_TAGS = [
        "Back",
        "Biceps",
        "Calves",
        "Chest",
        "Forearms",
        "Glutes",
        "Hamstrings",
        "Quadriceps",
        "Shoulders",
        "Triceps",
    ]

    belongs_to :workout, optional: false
    has_one :user, through: :workout
    has_many :exercise_sets, dependent: :destroy

    validates_presence_of :name

    def gemini_response_html
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        markdown.render self.gemini_response
    end
end
