class RepositoriesController < ApplicationController
		require 'cw-gitolite-client'
	#TODO filters
	
	def create
		@project = Project.find_by_id params[:project_id]
		repo_name = @project.location
		string_key = current_user.public_key
		user_name = current_user.name
		Codewatch::Repositories.new.configure do |git| # provides 20s timeout
			#TODO exception handling ->timeout throws one
			git.create repo_name, string_key, user_name
		end
		
		hook_location = @project.repo_location + '/hooks/post-receive'
		new_hook = File.new hook_location, 'w+'
		
		hook_template = File.open 'post-receive.hook.sample', 'r'
		hook_template.each do |line|
			new_hook.puts (line.gsub 'PROJECT_ID', @project.id.to_s)
		end
		
		new_hook.close
		hook_template.close
		
		File.chmod 0777, hook_location
		
		@project.repository_created = true
		if @project.save
			flash[:success] = "New repository created"
		else
			flash[:error] = "New repository created, but something unsuspected happened"
		end
			redirect_to project_path @project
	end

	def update_users
		@project = Project.find_by_id params[:project_id]
		repo_name = @project.location
		string_key = current_user.public_key
		user_name = current_user.name
		begin
			Codewatch::Repositories.new.configure do |git| # provides 20s timeout
				git.create repo_name, string_key, user_name
			end
		rescue
			flash[:error]="Set repository permissions error"
			redirect_to project_path @project
			return
		end
		flash[:notice]="Repository permissions updated "
	end



	private
	
	def repository_created?
		@project = Project.find params[:project_id]
		if @project.repository_created 
			flash[:error] = "No repository found. Create one"
			redirect_to project_path @project 
		end
	end

	def get_perm_string role
		if role = UserCompany::Role::OWNER
			"RW+"
		elsif role = UserCompany::Role::ADMIN
			"RW+"
		elsif role = UserCompany::Role::USER
			"RW+"
		elsif role = UserCompany::Role::SPECTATOR
			"R"
		end
	end
	
	
end
