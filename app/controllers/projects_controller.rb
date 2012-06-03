class ProjectsController < ApplicationController

	#TODO pbatko
	# before_filter correct_project? hmm @project.nil?

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	before_filter :have_public_key?, only: :new
	
	def index
		@projects = current_user.projects.find_all_by_company_id @company
	end

	def show
		@project = current_user.projects.find_by_id params[:id]
		@users = @project.users
		@logs = Log.order("logs.created_at desc").joins("LEFT JOIN tasks ON logs.task_id = tasks.id")
			.includes(:author, :project).select("logs.*, users.*, tasks.*").limit(100)
			.where('logs.project_id = ? AND (logs.user_id = ? OR logs.user_id is null)', @project, current_user.id)
	end

	def new 
		
		@project = @company.projects.build params[:project]
		@project.location = '.'
		if request.post? && @project.save
			@project.location = "#{@project.company.slug}/#{@project.slug}"
			@project.save
			flash[:success] = "New project created"
			redirect_to project_path @project
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
		
		@types = {'Select' => 0, 'SVN' => Project::TYPE_SVN, 'GIT' => Project::TYPE_GIT}
	end

	def edit
		@project = @company.projects.find_by_id params[:id]
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
		flash[:success] = "Project removed"
		redirect_to projects_path

	end

	def dashboard
		@projects = current_user.projects.find_all_by_company_id @company
		@logs = Log.order("logs.created_at desc").joins("LEFT JOIN tasks ON logs.task_id = tasks.id")
			.includes(:author, :project).select("logs.*, users.*, tasks.*").limit(100)
			.where('logs.project_id in (?) AND (logs.user_id = ? OR logs.user_id is null)', @projects, current_user.id)
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
