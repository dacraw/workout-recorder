json.extract! workout, :id, :name, :description, :muscle_group, :created_at, :updated_at
json.url workout_url(workout, format: :json)
