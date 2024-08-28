class ExerciseSet < ApplicationRecord
    belongs_to :exercise
    has_one :workout, through: :exercise

    validates_presence_of :exercise
    validate :validate_presence_of_reps_or_weight

    private

    def validate_presence_of_reps_or_weight
        fields = %i[ reps weight ]
        errors.add :base, "Either reps or weight must be present." if fields.all? {|field| self[field].blank? }
    end
end