class ChangeWorkoutsMuscleGroupToMuscleGroupId < ActiveRecord::Migration[7.1]
  def change
    remove_column :workouts, :muscle_group
    add_reference :workouts, :muscle_group, foreign_key: { to_table: :muscle_groups }
  end
end
