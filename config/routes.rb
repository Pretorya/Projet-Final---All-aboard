Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "feed#index", as: :authenticated_root
    get "feed" => "feed#index"
    get "explore" => "explore#index"
    get "my-posts" => "my_posts#index"

    resources :users, only: :show

    resources :posts, only: :create do
      member do
        post :delete
      end
    end

    resources :comments, only: :create do
      member do
        post :delete
      end
    end

    resources :likes, only: :create do
      member do
        post :delete
      end
    end

    resources :bookmarks, only: :create do
      member do
        post :delete
      end
    end

    resources :subject_requests, only: :create do
      member do
        post :delete
        post :update
      end
    end

    resources :conversations, path: "messages", only: [:index, :show, :create] do
      resources :messages, only: :create do
        member do
          post :delete
        end
      end
    end

    namespace :admin do
      get "dashboard", to: "dashboard#index"
      resources :posts,            only: [:index, :destroy]
      resources :users,            only: :index do
        member do
          post :promote_user
          post :promote_mentor
        end
      end
      resources :messages,         only: [:new, :create]
      resources :admins,           only: [:new, :create]
      resources :subject_requests, only: [:index, :update]
    end

    namespace :mentor do
      get "dashboard", to: "dashboard#index", as: :dashboard
    end

    resources :resources, only: [:index, :show, :new, :create]
  end

  unauthenticated do
    root "home#index"
  end

  resource :admin_setup, only: [:new, :create], path: "admin-setup"

  get  "legal/cgu",      to: "legal#cgu",        as: :legal_cgu
  get  "legal/privacy",  to: "legal#privacy",     as: :legal_privacy
  get  "legal/mentions", to: "legal#mentions",    as: :legal_mentions
  post "legal/accept",   to: "legal#accept_cgu",  as: :accept_cgu

  get "up" => "rails/health#show", as: :rails_health_check
end
