class Workout < ApplicationRecord
    include GeminiAssistant

    belongs_to :user
    has_many :exercises, dependent: :destroy

    validates :user, presence: true

    before_create :set_date

    def gemini_response_html
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        markdown.render self.gemini_response
    end

    private
    def set_date
        self.date = self.created_at if self.date.nil?
    end
end
