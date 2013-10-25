Tutor::Application.routes.draw do

  get  "tutorial", to: "tutorial#index"
  post "tutorial/assess", to: "tutorial#assess"
  get  "tutorial/search", to: "tutorial#search"
  post "tutorial/move", to: "tutorial#move"
  post "tutorial/create_student", to: "tutorial#create_student"

  get  "about", to: "about#index"

  get  "status", to: "status#new"
  post "status/create", to: "status#create"
  get  "status/show/:token", to: "status#show"

  get  "load", to: "load#index"
  post "load/tumonline", to: "load#tumonline"
  post "load/tutoren", to: "load#tutoren"

  get "users/:id/reset", to: "users#reset"

  devise_for :users

  resources :weeks
  resources :assessments
  resources :groups
  resources :courses
  resources :students
  resources :users

  root 'tutorial#index'

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
