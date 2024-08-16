Rails.application.routes.draw do
  devise_for :users

  resources :workouts, only: [:create, :new, :show, :destroy] do
    resources :exercises
  end
  get "my_workouts", to: "workouts#my_workouts"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
