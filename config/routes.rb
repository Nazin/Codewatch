Www::Application.routes.draw do


	resources :projects, except: [:create, :update]
	match '/projects/new', to: 'projects#new', via: :post
	match '/projects/:id/edit', to: 'projects#edit'

	resources :users, only: [:index]
	resources :code_snippets, only: [:index, :new, :create, :show] #TODO :destroy
	resources :cw_diffs, only: [:new, :create, :show]
	resources :sessions, only: [:new, :create, :destroy]

	match '/projects/dashbaoard', to: 'projects#dashboard'
	match '/code_snippets/tmp/:sha', to: 'code_snippets#show'

	match '/help', to: 'page#help'
	match '/about', to: 'page#about'
	match '/contact', to: 'page#contact'
	
	match '/signup', to: 'users#signup'
	match '/signin', to: 'users#signin'
	match '/signout', to: 'users#signout', via: :delete
	match '/activate/:key', to: 'users#activate'
	match '/users/edit', to: 'users#edit', as: :user_edit
	match '/users/:id', to: 'users#show'

	match '/dashboard', to: 'projects#dashboard'
	
	root to: 'page#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
