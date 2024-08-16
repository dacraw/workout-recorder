class ReCreateWorkouts < ActiveRecord::Migration[7.1]
  def change
    create_table :workouts do |t|
      t.date :date
      t.belongs_to :user

      t.timestamps
    end
  end
end
