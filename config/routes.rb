Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "feed#index", as: :authenticated_root
    get "feed" => "feed#index"
    get "explore" => "explore#index"
    get "my-posts" => "my_posts#index"

    resources :posts, only: [:create, :destroy]
    resources :comments, only: :create
    resources :likes, only: [ :create, :destroy ]
    resources :bookmarks, only: [ :create, :destroy ]
    resources :subject_requests, only: :create
    resources :conversations, path: "messages", only: [ :index, :show, :create ] do
      resources :messages, only: :create
    end

    # Admin routes
    get "admin/dashboard" => "admin#dashboard", as: :admin_dashboard
    get "admin/posts" => "admin#posts", as: :admin_posts
    delete "admin/posts/:id" => "admin#delete_post", as: :admin_delete_post
    get "admin/users" => "admin#users", as: :admin_users
    get "admin/send-message" => "admin#send_message_form", as: :admin_send_message_form
    post "admin/send-message" => "admin#send_message_to_user", as: :admin_send_message_to_user
    get "admin/create-admin" => "admin#create_admin_form", as: :admin_create_admin_form
    post "admin/create-admin" => "admin#create_admin", as: :admin_create_admin
  end

  unauthenticated do
    root "home#index"
  end

  get "admin-setup" => "admin_setup#create_admin_form", as: :admin_setup_form
  post "admin-setup" => "admin_setup#create_admin", as: :admin_setup_create_admin

  get "up" => "rails/health#show", as: :rails_health_check
end
