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
		
		if not commits[1].nil?
			@diffs = Grit::Commit.diff repo, commits[1].id, params[:id]
		else
			@diffs = get_tree_diffs @commit.tree, [], ''
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
		
		if params[:parent]
			"""parent: @tree is needed, to obtain @blob object with :name field"""
			@tree = repo.tree params[:parent]

			@blob = @tree.blobs.find { |b| b.id == params[:blob_id] }
		else
			"""here @blob object has only :id field"""
			@blob =	repo.blob params[:blob_id]
		end

		@text = @blob.data

		@textfile =  (@blob.name =~ /\.rb|\.js/i) || (@textfile = @text.ascii_only?)


		if @textfile
			@lines = @text.lines.count
			@highlighted = Pygments.highlight(@text )
		end

	end



private

	def get_tree_diffs tree, elements, path
		
		for el in tree.contents
			
			if el.is_a? Grit::Tree
				elements = get_tree_diffs el, elements, (path != '' ? (File.join path, el.name) : el.name)
			else
				
				temp = Server::ServerDiff.new
				temp.deleted_file = false
				temp.new_file = false
				temp.a_blob = el.id
				temp.a_path = path != '' ? (File.join path, el.name) : el.name
				
				elements.push temp
			end
		end
		
		elements
	end
	
	def root_tree
		repo = @project.repo
		tree = repo.commits.first.tree
		@parent = tree
		process_tree tree
#		tree.id # => "3536eb9abac69c3e4db583ad38f3d30f8db4771f"
	end 

	def sub_tree
		repo = @project.repo
		tree =	repo.tree params[:tree_id]
		@parent = tree
		process_tree tree
# => #<Grit::Tree "91169e1f5fa4de2eaea3f176461f5dc784796769">
	end

	def process_tree tree
		contents = tree.contents
		@blobs = tree.blobs
		@trees = tree.trees
	end
end
