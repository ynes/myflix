Myflix::Application.routes.draw do
  root to: "pages#front"
  resources :categories
  resources :users
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  resources :videos do
    resources :reviews, only: [:create]
    collection do
      post "search"
    end
  end

  get '/home' => 'home#index'
  get "/register" => 'users#new' 
  get "/sign_in" => 'sessions#new' 
  get "/sign_out" => "sessions#destroy"
  get "/my_queue", to: 'queue_items#index'
  get "/update_queue", to: "queue_items#update_queue"


  get 'ui(/:action)', controller: 'ui'
end
