class AddWorkoutReferenceToExercises < ActiveRecord::Migration[7.1]
  def change
    add_reference :exercises, :workout, foreign_key: { to_table: :workouts}
  end
end
