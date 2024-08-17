class AddDateToExercise < ActiveRecord::Migration[7.1]
  def change
    add_column :exercises, :date, :datetime, default: Time.now
  end
end
