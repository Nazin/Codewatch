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

	def tree
		if params[:tree_id]
			sub_tree
		else
			root_tree
		end
	end


private

	def root_tree
		repo = @project.repo
		tree_from_repo repo
#		tree.id # => "3536eb9abac69c3e4db583ad38f3d30f8db4771f"
	end 

	def sub_tree
		repo =	repo.tree params[:tree_id]
		tree_from_repo repo
# => #<Grit::Tree "91169e1f5fa4de2eaea3f176461f5dc784796769">
	end

	def tree_from_repo repo
		tree = repo.commits.first.tree
		contents = tree.contents
		@blobs = tree.blobs
		@trees = tree.trees
	end
end
