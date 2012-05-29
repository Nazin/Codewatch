class TasksHistoriesController < ApplicationController

	def index
		@task = Task.find_by_id params[:task_id]
		@tasks_histories = @task.tasks_histories
	end


	def show
		@task = Task.find_by_id params[:task_id]
		@tasks_history = @task.tasks_histories.find_by_id params[:id]
	end


end
