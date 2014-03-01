Tutor::Application.routes.draw do

  get "chat/:room", to: "chat#nickname"
  get "chat/:room/:nickname", to: "chat#index"
  post "chat/:room/:nickname", to: "chat#write"
  get "chat/:room/:nickname/refresh/:lastid", to: "chat#refresh"

  resources :exams

  resources :rooms

  resources :analyses

  get  "tutorial", to: "tutorial#index"
  post "tutorial/assess", to: "tutorial#assess"
  get  "tutorial/search", to: "tutorial#search"
  post "tutorial/move", to: "tutorial#move"
  post "tutorial/create_student", to: "tutorial#create_student"
  post "tutorial/settings", to: "tutorial#settings"
  post "tutorial/email", to: "tutorial#email"

  get  "about", to: "about#index"
  get  "analyses/:id/execute", to: "analyses#execute"

  get  "status", to: "status#new"
  post "status/create", to: "status#create"
  get  "status/show/:token", to: "status#show"
  get  "status/schedule", to: "status#schedule"
  get  "schedule", to: "status#schedule"

  get  "load", to: "load#index"
  post "load/tumonline", to: "load#tumonline"
  post "load/tutoren", to: "load#tutoren"

  get "users/:id/magiclogin/:magictoken", to: "users#magiclogin"
  get "users/:id/reset", to: "users#reset"
  get "users/:id/associate", to: "users#associate"

  post "exams/:id/assign_seats", to: "exams#assign_seats"
  post "exams/:id/reset_seats", to: "exams#reset_seats"
  get "exams/:id/print_roomdoor", to: "exams#print_roomdoor"
  get "exams/:id/print_signatures", to: "exams#print_signatures"
  get "exams/:id/export_seats", to: "exams#export_seats"
  get "exams/:id/export_grades", to: "exams#export_grades"
  get "exams/:id/grade/:magictoken", to: "exams#grade"
  post "exams/:id/grade/:magictoken", to: "exams#grade_save"
  get "exams/:id/score", to: "exams#score"
  post "exams/:id/score", to: "exams#apply_score"

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
