Rails.application.routes.draw do
  get "login", to: "sessions#new"
  post "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "forgot_password", to: "sessions#forgot_password"
  post "send_reset_link", to: "sessions#send_reset_link"
  get "password/reset/:token", to: "sessions#edit_password_reset", as: :edit_password_reset
  patch "password/reset/:token", to: "sessions#update_password_reset", as: :update_password_reset
  root "home#index"
  get "signup", to: "users#signup"
  post "signup", to: "users#create"
  resources :stocks
  get "analytics", to: "analytics#index"
  resources :users, only: [:index, :edit, :update, :destroy] do
    collection do
      get :notifications
      get :appearance
    end
  end
  get  "verify-signup", to: "users#verify_signup"
  post "verify-signup", to: "users#confirm_signup"

  get "up" => "rails/health#show", as: :rails_health_check
end
