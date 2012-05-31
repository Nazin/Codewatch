class RepositoriesController < ApplicationController
		require 'cw-gitolite-client'
	#TODO filters
	
	def create
		@project = Project.find_by_id params[:id]
		repo_name = @project.location
		string_key = current_user.public_key
		user_name = current_user.name
		Codewatch::Repositories.new.configure do |git| # provides 20s timeout
			#TODO exception handling ->timeout throws one
			git.create repo_name, string_key, user_name
		end
		@project.repository_created = true
		if @project.save
			flash[:success] = "New repository created"
		else
			flash[:error] = "New repository created, but something unsuspected happened"
		end
			redirect_to project_path @project
	end

	def update_users

	end


end
