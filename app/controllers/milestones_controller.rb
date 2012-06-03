class MilestonesController < ApplicationController

	def index 
		@project = Project.find_by_id params[:project_id]
		@milestones = @project.milestones
	end


	def new 
		@project = Project.find_by_id params[:project_id]
		if request.post?
			@milestone =@project.milestones.build params[:milestone]
			if @milestone.save
				flash[:success] = "New milestone created"
				redirect_to project_milestones_path @project
			else
				flash[:warning] = "Invalid information "
				@milestone = @project.milestones.build
			end
		else #GET
			@milestone = @project.milestones.build
		end
	end

	def show
		@project = Project.find_by_id params[:project_id]
		@milestone = @project.milestones.find_by_id params[:id]
		@tasks = @milestone.tasks
	end

	def edit
		@project = Project.find_by_id params[:project_id]
		if request.put?
			@milestone =@project.milestones.find_by_id params[:id]
			if @milestone.update_attributes params[:milestone]
				flash[:success] = "Mmilestone updated"
				redirect_to project_milestone_path @project, @milestone
			else
				flash[:warning] = "Invalid information "
			end
		else #GET
			@milestone =@project.milestones.find_by_id params[:id]
		end
	end


	

	def destroy
		@project = Project.find_by_id params[:project_id]
		@milestone = @project.milestones.find_by_id params[:id]
		@tasks = @milestone.tasks
		if @tasks || !@tasks.empty?
			@milestone.destroy
			flash[:success] = "Milestone removed"
			redirect_to project_milestones_path @project
		else
			flash[:success] = "Cannot remove milestone - milestone has tasks"
			redirect_to project_milestone_path @project, @milestone
		end
	end
end
