class SourceController < ApplicationController
	
	before_filter :company_member?
	
	def index
		repo = @project.repo
		@commits = repo.commits
	end
	
	def show
		
		repo = @project.repo
		commits = repo.commits params[:id]
		@commit = commits.first
		
		if commits[1].nil?
			@diffs = Grit::Commit.diff repo, params[:id]
		else
			@diffs = Grit::Commit.diff repo, commits[1].id, params[:id]
		end
	end
end
