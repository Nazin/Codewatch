class ProjectsController < ApplicationController

	#TODO pbatko
	# before_filter correct_project? hmm @project.nil?

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	before_filter :have_public_key?, only: :new
	
	def index
		#TODO brac projekty tylko z aktualnej firmy!!
		@projects = current_user.projects
	end

	def show
		@project = current_user.projects.find_by_id params[:id]
		@users = @project.users
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
		@projects = current_user.projects
		#TODO pbatko
		#introduce DashboardsController ?
	end
	
	private



	def company_admin?
		role = UserCompany::Role.new @company, current_user
		role.admin?
	end

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
