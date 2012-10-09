# -*- coding: utf-8 -*-
Www::Application.routes.draw do

	match '/projects/:project_id/comments/new', to: 'comments#new', via: :post, as: :new_comment
	match '/projects/:project_id/comments/:id', to: 'comments#destroy', via: :delete, as: :delete_comment
	match '/projects/:project_id/comments/:id', to: 'comments#show', via: :get, as: :get_comment
	match '/projects/:project_id/comments/:id/new', to: 'comments#new2', via: :post, as: :new_comment_comment

	match '/projects/:project_id/branch/:branch/tree/:path/blob/:blob_id/', to: 'source#blob', via: :get, as: :project_parent_branch_blob
	match '/projects/:project_id/branch/:branch/blob/:blob_id/', to: 'source#blob', via: :get, as: :project_branch_blob
	match '/projects/:project_id/branch/:branch/tree', to: 'source#tree', via: :get, as: :project_branch_root_tree
	match '/projects/:project_id/branch/:branch/tree/:path', to: 'source#tree', via: :get, as: :project_branch_tree
	match '/projects/:project_id/branch/:branch', to: 'source#index', via: :get, as: :project_branch
	match '/projects/:project_id/branch/:branch/commit/:commit_id', to: 'source#show', via: :get, as: :project_branch_commit

	match '/projects/:project_id/repository', to: 'repositories#create', via: [:get], as: :create_project_repo
	match '/projects/:project_id/repository/update_users', to: 'repositories#update_users', via: [:get], as: :update_project_repo_users

	match '/projects/new', to: 'projects#new', via: [:get, :post], as: :new_project
	match '/projects/:id/edit', to: 'projects#edit', via: [:get, :put], as: :edit_project

	match '/projects/:project_id/tasks/new', to: 'tasks#new', via: :post, as: :new_project_task
	match '/projects/:project_id/tasks/:id/edit', to: 'tasks#edit', via: :put, as: :edit_project_task

	match '/projects/:project_id/milestones/new', to: 'milestones#new', via: :post, as: :new_project_milestone
	match '/projects/:project_id/milestones/:id/edit', to: 'milestones#edit', via: :put, as: :edit_project_milestone

	resources :projects, except: [:create, :update] do
		resources :tasks, except: [:create, :update]
		resources :servers, except: [:create, :update, :show]
		resources :source, only: :index
		resources :milestones
	end

	match '/projects/:project_id/servers/new', to: 'servers#new', via: [:get, :post], as: :new_server
	match '/projects/:project_id/servers/:id/edit', to: 'servers#edit', via: [:get, :put], as: :edit_server
	match '/projects/:project_id/servers/:id/deploy', to: 'servers#deploy', via: [:get], as: :deploy_server

	match '/users/edit', to: 'users#edit', as: :user_edit
	match '/users/:id/edit', to: 'users#update', as: :users_edit
	match '/users/invite', to: 'users#invite'
	match '/users/remove_avatar', to: 'users#remove_avatar', via: :delete

	resources :users, only: [:index, :show, :destroy]
	resources :code_snippets, only: [:index, :new, :create, :show] #TODO :destroy
	resources :cw_diffs, only: [:new, :create, :show]
	resources :sessions, only: [:new, :create, :destroy]

	match '/projects/dashbaoard', to: 'projects#dashboard'
	match '/code_snippets/tmp/:sha', to: 'code_snippets#show'

	match '/help', to: 'page#help'
	match '/about', to: 'page#about'
	match '/contact', to: 'page#contact'

	match '/signup', to: 'users#signup'
	match '/signup/:key', to: 'users#signup'
	match '/signin', to: 'users#signin'
	match '/signout', to: 'users#signout', via: :delete
	match '/activate/:key', to: 'users#activate'

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
