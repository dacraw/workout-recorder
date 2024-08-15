class Workout < ApplicationRecord
    belongs_to :user
    has_many :exercises

    validates :user, presence: true

    before_create :set_date

    private
    def set_date
        self.date = self.created_at if self.date.nil?
    end
end
