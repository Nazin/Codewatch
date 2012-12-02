class MilestonesController < ApplicationController

	def new

		@milestone = @project.milestones.build params[:milestone]

		if request.post? && @milestone.save
			flash[:succes] = "New milestone created"
			redirect_to project_tasks_path
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
	end

	def show
		
		page = get_page
		
		@milestone = @project.milestones.find_by_id params[:id]
		@tasks = @milestone.tasks.limit(15).offset((page-1)*15)
		
		if request.xhr?
			render @tasks, :layout => false
		end
	end

	def edit

		@milestone = @project.milestones.find_by_id params[:id]

		if request.put? and @milestone.update_attributes params[:milestone]
			flash[:succes] = "Milestone updated"
			redirect_to project_tasks_path
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
