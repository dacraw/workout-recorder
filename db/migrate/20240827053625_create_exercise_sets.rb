class CreateExerciseSets < ActiveRecord::Migration[7.1]
  def change
    create_table :exercise_sets do |t|
      t.belongs_to :exercise, null: false, foreign_key: true
      t.integer :reps
      t.float :weight
      t.string :weight_unit
      t.text :description

      t.timestamps
    end
  end
end
