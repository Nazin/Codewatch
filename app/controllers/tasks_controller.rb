class TasksController < ApplicationController
	#TODO some/more filters ?

	before_filter :owner_or_admin1n?, only: [:new, :edit, :destroy]

	def index
		#TODO nested resources projects/:id/tasks 
		@project = Project.find_by_id 6
		@tasks = tasks_of current_user, @company, @project
	end


private

	def owner_or_admin?
		company_owner? || company_admin?
	end


	#TODO pbatko scopes?
	def tasks_of user, company, project
		user_id = user.id
		company_id = company.id
		project_id = project.id
		Task.joins( project: {company: :users}  ).where(users: { id: user_id }, companies: { id: company_id }, projects: { id: project_id })
	end
end
