class SourceController < ApplicationController
	include CodeSnippetsHelper

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

	def blob
		repo = @project.repo
		blob =	repo.blob params[:blob_id]
		@name = blob.name
		@id = blob.id
		@text = blob.data
		@textfile = @text.ascii_only?
		if @textfile
			#TODO assumptions that text is text
			@lines = @text.lines.count
			#TODO use Pygments lexer autodetect lang 
			@highlighted = Pygments.highlight(@text )
		end

	end



private

	def root_tree
		repo = @project.repo
		tree = repo.commits.first.tree
		process_tree tree
#		tree.id # => "3536eb9abac69c3e4db583ad38f3d30f8db4771f"
	end 

	def sub_tree
		repo = @project.repo
		tree =	repo.tree params[:tree_id]
		process_tree tree
# => #<Grit::Tree "91169e1f5fa4de2eaea3f176461f5dc784796769">
	end

	def process_tree tree
		contents = tree.contents
		@blobs = tree.blobs
		@trees = tree.trees
	end
end
