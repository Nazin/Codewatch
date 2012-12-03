class MilestonesController < ApplicationController

	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	before_filter :init_task_filter
	
	def new

		@milestone = @project.milestones.build params[:milestone]

		if request.post? && @milestone.save
			flash[:succes] = "New milestone created"
			redirect_to project_tasks_path
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
	end

	def filter
		task_filter
		@milestone = @project.milestones.find_by_id params[:id]
		redirect_to project_milestone_path @project, @milestone
	end
	
	def show
		
		@milestone = @project.milestones.find_by_id params[:id]
		@tasks = get_tasks @milestone.tasks
		
		if request.xhr?
			render @tasks, :layout => false
		end
	end

	def edit

		@milestone = @project.milestones.find_by_id params[:id]

		if request.put? and @milestone.update_attributes params[:milestone]
			flash[:succes] = "Milestone updated"
			redirect_to project_milestone_path(@project, @milestone)
		elsif request.put?
			flash[:warning] = "Invalid information"
		end
	end

	def destroy

		@milestone = @project.milestones.find_by_id params[:id]

		if @milestone.tasks.any?
			flash[:success] = "Cannot remove milestone - milestone has tasks"
			redirect_to project_milestone_path @project, @milestone
		else
			@milestone.destroy
			flash[:success] = "Milestone removed"
			redirect_to project_tasks_path
		end
	end
end
