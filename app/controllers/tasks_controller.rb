class TasksController < ApplicationController
	#TODO some/more filters ?

	before_filter :company_admin?, only: [:new, :edit, :destroy]

	def index

		#TODO before filter which inits @projects and redirects if @projects == nil 
		@project = Project.find_by_id params[:project_id]
		if @project.nil?
			flash[:warning]= "Project not found"
			redirect_to root_path
		else
			@tasks = tasks_of current_user, @company, @project
		end
	end


	
	def new 
		@project = Project.find_by_id params[:project_id]
		if request.post?
			@task = @project.tasks.build params[:task]
			@task.posted = 0.days.ago
			@task.updated = @task.posted
			#TODO temporary, Nazin zrobi ladny jsowy kalendarz :)
			@task.deadline = 2.days.from_now
			if @task.save
				flash[:succes] = "New task created"
				redirect_to project_tasks_path @project
			else
				flash[:warning] = "Invalid information"
			end
		else #get
			@task = @project.tasks.build
			@users = @project.users.all
		end
	end


	def show
		@project = Project.find_by_id params[:project_id]
		@task = @project.tasks.find_by_id params[:id]
		if @project.nil?
			flash[:warning]= "Project not found"
			redirect_to root_path
		end
	end

	def edit
		if request.put? 

			@project = Project.find_by_id params[:project_id]
			@task = @project.tasks.find_by_id params[:id]
			if @task.update_attributes params[:task]
				flash[:succes] = "Task updated"
				redirect_to project_tasks_path(@project)
			else 
				flash[:warning] = "Invalid information"
			end
		else #get
			@project = Project.find_by_id params[:project_id]
			@task = @project.tasks.find_by_id params[:id]
			@users = @project.users.all
		end
	end

	def destroy
		@project = Project.find_by_id params[:project_id]
		@task = Task.find_by_id params[:id]
		@task.destroy
		flash[:success] = "Task removed"
		redirect_to project_tasks_path @project

	end


private

	#TODO pbatko scopes?
	def tasks_of user, company, project
		""" builds sql query to select of given user, company, project"""
		user_id = user.id
		company_id = company.id
		project_id = project.id
		Task.joins( project: {company: :users}  ).where(users: { id: user_id }, companies: { id: company_id }, projects: { id: project_id })
	end
end
