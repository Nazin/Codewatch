class ProjectsController < ApplicationController
	require 'cw-gitolite-client'
	#TODO pbatko
	# before_filter correct_project? hmm @project.nil?

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	before_filter :have_public_key?, only: :new
	
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
			if create_git_repo!
				flash[:succes] = "New project created"
				redirect_to projects_path
			end
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

	def create_git_repo!
		repo_name = "#{@project.company.name}/#{@project.company.name}-#{@project.name}"
#		repo_name = "#{@project.company.name}-#{@project.name}"
		string_key = current_user.public_key
		Codewatch::Repositories.new.configure do |git| # provides 20s timeout
			#TODO exception handling ->timeout throws one
			ga_repo = git.ga_repo
			conf = git.conf
			
			repo = git.new_repo repo_name
			key = git.new_key string_key, current_user.name
			
			repo.add_permission "RW+","","#{current_user.name}"
			ga_repo.add_key key
			conf.add_repo repo
			ga_repo.save
		end

	end


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
