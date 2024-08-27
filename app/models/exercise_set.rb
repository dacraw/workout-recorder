class ExerciseSet < ApplicationRecord
    belongs_to :exercise
    has_one :workout, through: :exercise

    validates_presence_of :exercise
end