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

		@textfile = (@blob.name =~ /\.rb|\.js/i) || (@textfile = @text.ascii_only?)
		
		if @textfile
			
			@lines = @text.lines.count
			
			lexer = nil
			
			if @blob.name =~ /\./i
				parts = @blob.name.split '.'
				lexer = Pygments::Lexer.find_by_extname '.' + parts[parts.length-1]
			end
		
			if lexer.nil?
				@highlighted = Pygments.highlight @text
			else
				@highlighted = lexer.highlight @text
			end
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
				temp.tree = tree
				
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
	end 

	def sub_tree
		repo = @project.repo
		tree =	repo.tree params[:tree_id]
		@parent = tree
		process_tree tree
	end

	def process_tree tree
		@blobs = tree.blobs
		@trees = tree.trees
	end
end
