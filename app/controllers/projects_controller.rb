class ProjectsController < ApplicationController

	require 'cw-gitolite-client'

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	before_filter :have_public_key?, only: :new

	def index
		@projects = @company.projects
	end

	def show
		
		page = get_page
		
		@project = @company.projects.find_by_id params[:id]
		@users = @project.users
		@logs = Log.order("logs.created_at desc").joins("LEFT JOIN tasks ON logs.task_id = tasks.id").includes(:author, :project).select("logs.*, users.*, tasks.*").limit(100).offset((page-1)*100).where('logs.project_id = ? AND (logs.user_id = ? OR logs.user_id is null)', @project, current_user.id)
		
		if request.xhr?
			render '_logs', :layout => false
		end
	end

	def new

		@project = @company.projects.build params[:project]
		@project.location = '.'

		if request.post? && @project.save
			@project.location = "#{@project.company.slug}/#{@project.slug}"
			@project.save
			create_repo
			update_repo_perms
			flash[:success] = "New project created"
			redirect_to project_path @project
		elsif request.post?
			flash[:warning] = "Invalid information"
		end

		@employees = @company.users.find(:all, :order => 'name')
	end

	def edit

		@project = @company.projects.find_by_id params[:id]
		@company_employees = @company.users.find(:all, :order => 'name')

		if request.put? and @project.update_attributes params[:project]
			flash[:success] = "Project updated"
			redirect_to projects_path
		elsif request.put?
			flash[:warning] = "Invalid information"
		end
	end

	def destroy

		@project = current_user.projects.find_by_id params[:id]
		@project.destroy
		Codewatch::Repositories.new.configure do |git| # provides 20s timeout
			git.destroy_repo @project
		end

		flash[:success] = "Project removed"
		redirect_to projects_path
	end

	def dashboard
		
		page = get_page
		
		@projects = current_user.projects.find_all_by_company_id @company
		@logs = Log.order("logs.created_at desc").joins("LEFT JOIN tasks ON logs.task_id = tasks.id").includes(:author, :project).select("logs.*, users.*, tasks.*").limit(100).offset((page-1)*100).where('logs.project_id in (?) AND (logs.user_id = ? OR logs.user_id is null)', @projects, current_user.id)
		
		if request.xhr?
			render '_logs', :layout => false
		end
	end

private

	def have_public_key?

		if current_user.public_key.blank?
			flash[:warning] = "Cannot create project - no public key for git repository"
			redirect_to user_edit_path
			false
		else
			true
		end
	end
end
