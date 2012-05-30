class ProjectsController < ApplicationController
	require 'cw-gitolite-client'
	#TODO pbatko
	# before_filter correct_project? hmm @project.nil?

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	
	def index
		@projects = current_user.projects
	end

	def show
		@project = current_user.projects.find_by_id params[:id]
		@users = @project.users
	end

	def new 
		
		@project = @company.projects.build params[:project]
		
		if request.post? && @project.save
			#MOVETO: model create_hook or RepositoriesController
			conf = Codewatch::Repositories.new.conf
			conf.add_repo @project.name 
			##
			flash[:succes] = "New project created"
			redirect_to projects_path
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
		
		@types = {'Select' => 0, 'SVN' => Project::TYPE_SVN, 'GIT' => Project::TYPE_GIT}
	end

	def edit
		@project = @company.projects.find_by_id params[:id]
		if request.put? and @project.update_attributes params[:project]
			flash[:succes] = "Project updated"
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
		@projects = current_user.projects
		#TODO pbatko
		#introduce DashboardsController ?
	end
	
	private

	def company_admin?
		role = UserCompany::Role.new @company, current_user
		role.admin?
	end

end
