Rails.application.routes.draw do
  devise_for :users

  resources :workouts, only: [:index, :create, :show, :destroy] do
    member do
      get 'evaluate_workout', to: "workouts#evaluate_workout"
      get 'suggest_exercise_based_on_type', to: "workouts#suggest_exercise_based_on_type"
    end

    resources :exercises do
      resources :exercise_sets, only: [:index, :new]
    end
  end
  get "my_workouts", to: "workouts#my_workouts"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
end
