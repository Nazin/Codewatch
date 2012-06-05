class RepositoriesController < ApplicationController
	
	require 'cw-gitolite-client'
	
	before_filter :company_member?
	before_filter :company_admin?, only: [:create, :update_users]
	
	def create
		create_repo
		update_repo_perms
		redirect_to project_path @project
	end

	def update_users
		
		begin
			Codewatch::Repositories.new.configure do |git| # provides 20s timeout
				git.set_project_permissions @project
			end
		rescue
			flash[:error]="Set repository permissions error"
			redirect_to project_path @project
			return
		end
		
		flash[:notice]="Repository permissions updated "
		redirect_to project_path @project
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
		if role == UserCompany::Role::OWNER
			"RW+"
		elsif role == UserCompany::Role::ADMIN
			"RW+"
		elsif role == UserCompany::Role::USER
			"RW+"
		elsif role == UserCompany::Role::SPECTATOR
			"R"
		end
	end
end
