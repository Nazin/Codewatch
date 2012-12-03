class TasksController < ApplicationController

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	before_filter :init_task_filter

	def index
		
		@tasks = get_tasks @project.tasks
		@milestones = @project.milestones.find(:all, :order => 'deadline')
		
		if request.xhr?
			render @tasks, :layout => false
		end
	end

	def filter
		task_filter
		redirect_to project_tasks_path
	end
	
	def new

		@task = @project.tasks.build params[:task]
		@task.owner = current_user

		if request.post? && @task.save
			log_task_assignment
			flash[:succes] = "New task created"
			redirect_to project_tasks_path
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
	end

	def show
		@task = @project.tasks.find_by_id params[:id]
	end

	def edit

		@task = @project.tasks.find_by_id params[:id]
		@assigned_user_was = @task.assigned_user
		@task.owner = current_user

		if request.put? and @task.update_attributes params[:task]
			log_task_assignment @assigned_user_was != @task.assigned_user
			flash[:succes] = "Task updated"
			redirect_to project_task_path @project, @task
		elsif request.put?
			flash[:warning] = "Invalid information"
		end
	end

	def destroy
		@task = Task.find_by_id params[:id]
		@task.destroy
		flash[:success] = "Task removed"
		redirect_to project_tasks_path @project
	end

private

	def log_task_assignment do_it=true
		if do_it
			Log.it Log::Type::TASK_ASSIGNMENT, @project, current_user, {task: @task, user: @task.assigned_user}
		end
	end
end
