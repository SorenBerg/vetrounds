Vetrounds::Application.routes.draw do
  get "agree/:answer_id" => "agreements#new", as: "agree"
  get "agree_remove/:answer_id" => "agreements#destroy", as: "agree_remove"
  get "thank/:answer_id" => "thanks#new", as: "thanks"
  get "thanks_remove/:answer_id" => "thanks#destroy", as: "thanks_remove"
  post "answers/create"
  get "questions/new"
  post "questions/create"
  get "users/new"
  post "users/create_client"
  post "users/create_vet"
  get "users/show/:id" => 'users#show', as: :user_show
  get "questions/show/:id" => 'questions#show', as: :question_show
  post "questions/newpost" => 'questions#newpost', as: :home_question_post
  root "static_pages#home"
  get "terms" => "static_pages#terms", as: :terms

  get "signup" => "users#new", as: :signup
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create", as: :loginpost
  get "logout" => "sessions#destroy", as: :logout
  get "questions" => "questions#list", as: :listquestions

  get "admin" => "admin#listvet", as: :admin
  get "admin/login" => "admin#login", as: :admin_login
  post "admin/loginpost" => "admin#loginpost", as: :admin_login_post
  get "admin/clients" => "admin#listclient", as: :admin_clients
  get "admin/createclient" => "admin#createclient", as: :admin_create_client
  post "admin/createclient" => "admin#createclientpost", as: :admin_create_client_post
  get "admin/createvet" => "admin#createvet", as: :admin_create_vet
  post "admin/createvet" => "admin#createvetpost", as: :admin_create_vet_post
  get "admin/client/:id" => "admin#viewclient", as: :admin_view_client
  get "admin/vet/:id" => "admin#viewvet", as: :admin_view_vet
  get "admin/vet/:id/enable" => "admin#enablevet", as: :admin_enable_vet
  get "admin/vet/:id/disable" => "admin#disablevet", as: :admin_disable_vet
  get "admin/client/:id/enable" => "admin#enableclient", as: :admin_enable_client
  get "admin/client/:id/disable" => "admin#disableclient", as: :admin_disable_client

  get "search", to: "questions#search", as: :search

  post "share_answer/:id", to: "answers#share_answer", as: :share_answer

  get "password_forgot", to: "sessions#forgot", as: :password_forgot
  post "password_forgot", to: "sessions#forgot_post", as: :password_forgot_post
  get "password_reset/:id", to: "sessions#reset", as: :password_reset
  post "password_reset/:id", to: "sessions#reset_post", as: :password_reset_post

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
