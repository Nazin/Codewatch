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
			string_key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCswGFC8OeaYOhXbqua4IQBprhSqm/9/ZkJQ3vzmdAyaWx6ycA7sW8ExX+rZdnUVSHvJ6poNM5rA/h8pJnRs/ZkwheeiipZA36oWgksu9GJxf1VbmbfoMZ9zlEwPrM0kbzKWFrkvqTigywdLFFZX3a/fSCcvyZ7jeK+imKywZtRG6OvZbO+/Lhjs530JmOphxclKIemsMmjeoR1X+cEX5nRD+7ouQDetELIprJd4udWHy29tLqsars6P4yy3PUV9vidc+3f0bQa0b5SFs88q9CnlakgvxbJRCvte7EOcyeAZMAGuFa60Z1s5DPP2A5iTIRJoSB/nYYa1A9azftcTisf pbatko@pbatko-PC'
			cw_git = Codewatch::Repositories.new
			ga_repo = cw_git.ga_repo
			conf = cw_git.conf
			#get stuff
			repo = cw_git.new_repo @project.name
			key = cw_git.new_key string_key, "pbatko" #current_user.name
			#configure
			repo.add_permission "RW+","","#{current_user.name}"
			ga_repo.add_key key
			conf.add_repo repo

			ga_repo.save_and_apply # stage
#			ga_repo.apply # commit and (not work -> )push to origin master 
#			ga_repo.update #

			
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
