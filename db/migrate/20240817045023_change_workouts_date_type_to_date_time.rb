class ChangeWorkoutsDateTypeToDateTime < ActiveRecord::Migration[7.1]
  def change
    change_column :workouts, :date, :datetime
  end
end
