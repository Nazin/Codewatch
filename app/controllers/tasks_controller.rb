class TasksController < ApplicationController
	#TODO some/more filters ?

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]

	def index

		#TODO before filter which inits @projects and redirects if @projects == nil 
		
		if @project.nil?
			flash[:warning]= "Project not found"
			redirect_to root_path
		else
			@tasks = tasks_of current_user, @company, @project
		end
	end


	
	def new 
		
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
		
		@task = @project.tasks.find_by_id params[:id]
		if @project.nil?
			flash[:warning]= "Project not found"
			redirect_to root_path
		end
	end

	def edit
		if request.put? 

			
			@task = @project.tasks.find_by_id params[:id]
			if @task.update_attributes params[:task]
				flash[:succes] = "Task updated"
				redirect_to project_task_path(@project,@task)
			else 
				flash[:warning] = "Invalid information"
			end
		else #get

			@task = @project.tasks.find_by_id params[:id]
			@users = @project.users.all
		end
	end

	def destroy

		@task = Task.find_by_id params[:id]
		@task.destroy
		flash[:success] = "Task removed"
		redirect_to project_tasks_path @project

	end


private

	def company_admin?
		role = UserCompany::Role.new @company, current_user
		role.admin?
	end



	#TODO pbatko scopes?
	def tasks_of user, company, project
		""" builds sql query to select of given user, company, project"""
		user_id = user.id
		company_id = company.id
		project_id = project.id
		Task.joins( project: {company: :users}  ).where(users: { id: user_id }, companies: { id: company_id }, projects: { id: project_id })
	end
end
