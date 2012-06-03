class TasksHistoriesController < ApplicationController

	def index
		@task = Task.find_by_id params[:task_id]
		@project = @task.project
		@tasks_histories = @task.tasks_histories
	end


	def show
		@task = Task.find_by_id params[:task_id]
		@project = @task.project
		@tasks_history = @task.tasks_histories.find_by_id params[:id]
	
	end


end
