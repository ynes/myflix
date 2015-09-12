Myflix::Application.routes.draw do
  root to: "pages#front"
  resources :categories
  resources :relationships
  resources :users, only: [:create,:new,:show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :update, :destroy]
  resources :videos do
    resources :reviews, only: [:create]
    collection do
      post "search"
    end
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]

  get '/home' => 'home#index'
  get "/register" => 'users#new' 
  get "/sign_in" => 'sessions#new' 
  get "/sign_out" => "sessions#destroy"
  get "/my_queue", to: 'queue_items#index'
  post "/update_queue", to: "queue_items#update_queue"
  get "/people", to: "relationships#index"
  get "/forgot_password", to: "forgot_passwords#new" 
  get "/forgot_password_confirmation", to: "forgot_passwords#confirm"
  get "/expired_token", to: "pages#expired_token"
  get "register/:token", to: "users#new_with_invitation_token", as: "register_with_token"


  get 'ui(/:action)', controller: 'ui'
  resources :invitations, only: [:new, :create]
end
