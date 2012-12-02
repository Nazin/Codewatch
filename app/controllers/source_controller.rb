class SourceController < ApplicationController

	include CodeSnippetsHelper
	require 'diff/diff_service'

	before_filter :company_member?

	def index
		get_commits
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
			@commit2 = commits[1].id
			@diffs = Grit::Commit.diff repo, commits[1].id, @commit.id
		end
	end

	def tree

		get_branch_and_commit
		commit = get_commit @commit
		@tree = get_tree commit
	end

	def blob

		get_branch_and_commit
		commit = get_commit @commit
		@tree = get_tree commit
		
		if not @tree.nil? 
		
			@blob = find_blob @tree, params[:file]

			if not @blob.nil? 
				
				@textfile = textfile? @blob
				
				if @textfile

					@lines = @blob.data.lines.count+1

					lexer = nil

					if @blob.name =~ /\./i
						parts = @blob.name.split '.'
						lexer = Pygments::Lexer.find_by_extname '.' + parts[-1]
					end

					if lexer.nil?
						@highlighted = Pygments.highlight @blob.data
					else
						@highlighted = lexer.highlight @blob.data
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
				else

					@imagefile = imagefile? @blob

					if @imagefile
						@imagedata = Base64.encode64 @blob.data
					end
				end
			end
		end
	end

	def choose_diff
		
		get_branch_and_commit
		commit = get_commit @commit
		@tree = get_tree commit
		@chooseButton = true
		
		if not @tree.nil? 
		
			@blob = find_blob @tree, params[:file]

			if not @blob.nil? 
				get_commits
			end
		end
	end
	
	def diff
		
		get_branch_and_commit
		commit = get_commit @commit
		@tree = get_tree commit
		
		commit2 = get_commit params[:commit2]
		@tree2 = get_tree commit2
		
		if not @tree.nil? and not @tree2.nil?
			
			@blob = find_blob @tree, params[:file]
			@blob2 = find_blob @tree2, params[:file]
			
			if not @blob.nil? and not @blob2.nil? 
			
				@textfile = (textfile? @blob) and (textfile? @blob2)

				if @textfile
					
					lexer = nil

					if @blob.name =~ /\./i
						parts = @blob.name.split '.'
						lexer = Pygments::Lexer.find_by_extname '.' + parts[-1]
					end

					if lexer.nil?
						file1 = Pygments.highlight @blob.data
						file2 = Pygments.highlight @blob2.data
					else
						file1 = lexer.highlight @blob.data
						file2 = lexer.highlight @blob2.data
					end

					@size, @diff, @file_b = Codewatch::DiffService.line_diff @blob.data, @blob2.data, file1, file2, true
				else

					@imagefile = (imagefile? @blob) and (imagefile? @blob2)

					if @imagefile
						@imagedata = Base64.encode64 @blob.data
						@imagedata2 = Base64.encode64 @blob2.data
					end
				end
			end
		end
	end
	
private

	def textfile? blob
		(blob.mime_type =~ /^(text\/)|(application\/(xml|httpd-php|msdos-program|python|ruby|javascript|perl))/i) || (blob.data.ascii_only?)
	end
	
	def imagefile? blob
		['image/png', 'image/jpeg', 'image/gif'].include? blob.mime_type
	end
	
	def find_blob tree, file_name
		tree.blobs.find { |b| b.name.force_encoding('UTF-8') == file_name }
	end
	
	def get_commit commit_id
		
		repo = @project.repo
		
		if commit_id.nil? or commit_id == '-'
			commit = get_head_commit repo, @branch
		else
			commits = repo.commits commit_id
			commit = commits.first
		end
		
		commit
	end
	
	def get_tree commit
		
		@path = params[:path]
		
		if @path.nil? or @path == ' '
			@path = ''
			tree = commit.tree
		else
			@path.gsub! ':', '/'
			tree = commit.tree/@path
		end
		
		tree
	end
	
	def get_branch_and_commit
		
		@branch = params[:branch]
		@commit = params[:commit]
		
		if @commit.nil? or @commit == '-'
			@commit = '-'
		end
	end
	
	def get_head_commit repo, branch_name
		repo.commits(branch_name).first
	end

	def get_commits

		repo = @project.repo
		page = get_page
		
		@branches = repo.heads
		@current_branch_name = params[:branch] || repo.heads.first.name
		
		@current_branch_commits = repo.commits @current_branch_name, 15, (page-1)*15
		
		if request.xhr?
			render '_commits', :layout => false
		end
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
