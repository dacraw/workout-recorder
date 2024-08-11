class AddGeminiResponseToWorkouts < ActiveRecord::Migration[7.1]
  def change
    add_column :workouts, :gemini_response, :text
  end
end
