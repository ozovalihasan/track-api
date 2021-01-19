Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users, only: [:create]
  resources :tracked_items
  resources :pieces
  resources :taken_times , only: [:index, :create, :destroy]
  
  post "/login", to: "users#login"
  get "auto_login", to: "users#auto_login"
end
