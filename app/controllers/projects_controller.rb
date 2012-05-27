class ProjectsController < ApplicationController
	
	before_filter :can_access_company, only: [:dashboard]
	
	def index
		@projects = current_user.projects
	end

	def new 
		#TODO introduce current_company helper method? 
		@company = current_user.companies[0]
		@project = @company.projects.build params[:project]
		if request.post? && @project.save
			flash[:succes] = "New project created"
			redirect_to projects_path
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
	end

	def dashboard
		#TODO pbatko
		#introduce DashboardsController ?
	end
	

end
