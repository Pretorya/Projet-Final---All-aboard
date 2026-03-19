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
        post :delete, as: :delete_post
      end
    end

    resources :comments, only: :create do
      member do
        post :delete, as: :delete_comment
      end
    end

    resources :likes, only: :create do
      member do
        post :delete, as: :delete_like
      end
    end

    resources :bookmarks, only: :create do
      member do
        post :delete, as: :delete_bookmark
      end
    end

    resources :subject_requests, only: :create do
      member do
        post :delete, as: :delete_subject_request
        post :update
      end
    end

    resources :conversations, path: "messages", only: [:index, :show, :create] do
      resources :messages, only: :create do
        member do
          post :delete, as: :delete_message
        end
      end
    end

    # Admin routes
    namespace :admin do
      root action: 'dashboard'

      resources :posts, only: :index do
        member do
          post :delete, as: :delete_post
        end
      end

      resources :users, only: :index do
        member do
          post :promote, as: :promote_user
        end
      end

      resources :subject_requests, only: :index do
        member do
          post :update, as: :update_subject_request
        end
      end

      get "send-message", to: "admin#send_message_form", as: :send_message_form
      post "send-message", to: "admin#send_message_to_user", as: :send_message_to_user
      get "create-admin", to: "admin#create_admin_form", as: :create_admin_form
      post "create-admin", to: "admin#create_admin", as: :create_admin
    end
  end

  unauthenticated do
    root "home#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
