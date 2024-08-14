class ChangeWorkoutsToExercises < ActiveRecord::Migration[7.1]
  def change
    remove_reference :workouts, :muscle_group
    drop_table :muscle_groups
    rename_table :workouts, :exercises
  end
end
