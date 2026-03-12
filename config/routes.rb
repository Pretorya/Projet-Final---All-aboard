Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "feed#index", as: :authenticated_root
    get "feed" => "feed#index"
    get "explore" => "explore#index"

    resources :posts, only: :create
    resources :comments, only: :create
    resources :likes, only: [ :create, :destroy ]
    resources :bookmarks, only: [ :create, :destroy ]
    resources :conversations, path: "messages", only: [ :index, :show, :create ] do
      resources :messages, only: :create
    end
  end

  unauthenticated do
    root "home#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
