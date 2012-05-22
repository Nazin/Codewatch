class ProjectsController < ApplicationController
	
	before_filter :can_access_company, only: [:dashboard]
	
	def index
		@projects = current_user.projects



	def dashboard
		
	end
	
	def create
		
		@project = Project.new params[:project]
		
	end
end
