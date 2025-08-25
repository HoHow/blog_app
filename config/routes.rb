Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  
  # 使用 namespace 結構，通過 current_user 判斷使用者
  namespace :users do
    resources :posts do
      member do
        patch :publish
        patch :unpublish
        patch :delete
        patch :restore
      end
    end
  end
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  

  
  # 公開文章路由（明確指定路徑避免衝突）
  get "posts", to: "posts#index", as: :posts
  get "posts/:id", to: "posts#show", as: :post
  
  # 根路徑改為文章列表頁面
  root "posts#index"
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
