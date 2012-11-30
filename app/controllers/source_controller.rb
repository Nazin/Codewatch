class SourceController < ApplicationController

	include CodeSnippetsHelper

	before_filter :company_member?

	def index
		
		repo = @project.repo
		page = get_page
		
		@branches = repo.heads
		@current_branch_name = params[:branch] || repo.heads.first.name
		
		@current_branch_commits = repo.commits @current_branch_name, 15, (page-1)*15
		
		if request.xhr?
			render '_commits', :layout => false
		end
	end

	#shows given commit in a branch
	def show
		
		repo = @project.repo
		@branch = params[:branch]
		
		if params[:commit].nil? or params[:commit] == '-'
			commits = repo.commits @branch
		else
			commits = repo.commits params[:commit]
		end
		
		@commit = commits.first
		
		if commits[1].nil?
			@diffs = get_tree_diffs @commit.tree, [], ''
		else
			@diffs = Grit::Commit.diff repo, commits[1].id, @commit.id
		end
	end

	def tree

		repo = @project.repo
		@branch = params[:branch]
		@commit = params[:commit]
		
		if @commit.nil? or @commit == '-'
			@commit = '-'
			commit = get_head_commit repo, @branch
		else
			commits = repo.commits @branch
			commit = commits.find { |c| c.id == @commit }
		end
		
		if params[:path].nil?
			tree = commit.tree
		else
			@path = params[:path]
			@path.gsub! ':', '/'
			tree = commit.tree/@path
		end

		@tree = tree
	end

	def blob

		repo = @project.repo
		@branch = params[:branch]
		@path = params[:path]
		@commit = params[:commit]
		
		if @commit.nil? or @commit == '-'
			@commit = '-'
			commit = get_head_commit repo, @branch
		else
			commits = repo.commits @branch
			commit = commits.find { |c| c.id == @commit }
		end
		
		if params[:path].nil? or params[:path] == ' '
			@tree = commit.tree
			@path = ''
		else
			@path.gsub! ':', '/'
			@tree = commit.tree/@path
		end
		
		if not @tree.nil? 
		
			@blob = @tree.blobs.find { |b| b.name == params[:file] }
			@text = @blob.data
		
			@imagefile = ['image/png', 'image/jpeg', 'image/gif'].include? @blob.mime_type
			@imagedata = Base64.encode64 @text
			
			#TODO ? use blob.mime_type method - too many mime_types i guess
			@textfile = (@blob.name =~ /\.rb|\.js|\.php|\.css|\.txt/i) || (@textfile = @text.ascii_only?)

			if @textfile

				@lines = @text.lines.count+1

				lexer = nil

				if @blob.name =~ /\./i
					parts = @blob.name.split '.'
					lexer = Pygments::Lexer.find_by_extname '.' + parts[-1]
				end

				if lexer.nil?
					@highlighted = Pygments.highlight @text
				else
					@highlighted = lexer.highlight @text
				end

				#its needed for js selection
				@highlighted = @highlighted.gsub "</pre>\n</div>", '</div></pre></div>'
				@highlighted = @highlighted.gsub '<pre>', '<pre><div class="line">'
				@highlighted = @highlighted.gsub /\n/, '</div><div class="line">'
				@highlighted = @highlighted.gsub /\t/, '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
				@highlighted = @highlighted.gsub '<div class="line"></div>', '<div class="line">&nbsp;</div>'
				@highlighted = @highlighted.gsub '</pre></div></div><div class="line">', '</pre></div>'

				@comment = @project.comments.build params[:comment]
				@comment.blob = @blob.id
				@comment.file_name = @blob.name
				@comment.revision = commit.id
				@comment.path = @path
				@comment.branch = @branch

				@comments = @project.comments.order('"comments"."startLine"').find_all_by_path_and_blob @path, @blob.id

				@ccomment = CommentComment.new
			end
		end
	end

	private

	def get_head_commit repo, branch_name
		repo.commits(branch_name).first
	end

	def get_tree_diffs tree, elements, path

		for el in tree.contents

			if el.is_a? Grit::Tree
				elements = get_tree_diffs el, elements, (path != '' ? (File.join path, el.name) : el.name)
			else

				temp = Server::ServerDiff.new
				temp.deleted_file = false
				temp.new_file = true
				temp.a_blob = el.id
				temp.a_path = path != '' ? (File.join path, el.name) : el.name
				temp.tree = tree

				elements.push temp
			end
		end

		elements
	end
end
