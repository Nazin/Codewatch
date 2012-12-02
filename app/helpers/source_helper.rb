module SourceHelper

	def tree el

		if @path.nil? || @path == ''
			path = el.name
		else
			path = File.join @path, el.name
			path.gsub! '/', '%3A'
		end

		link_to el.name, project_branch_browse_path(@project.id, @branch, @commit, path)
	end

	def blob el
		link_to el.name, project_branch_file_path(@project.id, @branch, @commit, get_path, el.name)
	end

	def path_blob diff
		
		path = diff.a_path
		
		parts = path.reverse.split File::SEPARATOR, 2
		
		name = parts[0].reverse
		
		if parts.length == 1
			lpath = ' '
		else
			lpath = parts[1].reverse
			lpath.gsub! '/', '%3A'			
		end
		
		if diff.deleted_file
			path
		else
			if diff.new_file
				link_to path, project_branch_file_path(@project.id, @branch, @commit, lpath, name)
			else
				link_to path, project_diff_file_path(@project.id, @branch, @commit, lpath, name, @commit2)
			end
		end
	end
	
	def up_dir

		parts = @path.reverse.split File::SEPARATOR, 2

		if parts.length == 2
			path = parts[1].reverse
			path.gsub! '/', '%3A'
		else
			path = ''
		end

		link_to '..', project_branch_browse_path(@project.id, @branch, @commit, path)
	end
	
	def choose_diff 
		link_to "Diff with another revision", project_choose_diff_file_path(@project.id, @branch, @commit, get_path), :class => 'button r'
	end
	
	def diff rev
		link_to "Choose this revision", project_diff_file_path(@project.id, @branch, @commit, get_path, @blob.name, rev), :class => 'button r'
	end
	
	def breadcrumb files=true, file=false
		
		commit_name = @commit == '-' ? 'head commit' : "#{@commit} commit"
		
		breadcrumb = content_tag 'li', (link_to "#{@branch} branch", project_branch_path(@project.id, @branch))
		breadcrumb += content_tag 'li', (link_to commit_name, project_branch_commit_path(@project.id, @branch, @commit))
		breadcrumb += content_tag 'li', (link_to 'files', project_branch_browse_path(@project.id, @branch, @commit, '')) if files
	
		if not @path.nil?
			
			parts = @path.split File::SEPARATOR
			path = ''
			
			for part in parts
				
				path += part + '%3A'
				
				breadcrumb += content_tag 'li', (link_to part, project_branch_browse_path(@project.id, @branch, @commit, path[0..-4]))
			end
		end
	
		if not @blob.nil? and (not params[:commit2].nil? or file)
			path = @path
			
			if path.nil? || path == ''
				path = ' '
			end
			
			path.gsub! '/', '%3A'
			
			breadcrumb += content_tag 'li', (link_to @blob.name, project_branch_file_path(@project.id, @branch, @commit, path, @blob.name))
			breadcrumb += content_tag 'li', 'diff with ' + params[:commit2] + ' commit' if not params[:commit2].nil?
			breadcrumb += content_tag 'li', 'diff' if params[:commit2].nil?
		elsif not @blob.nil?
			breadcrumb += content_tag 'li', @blob.name
		end
		
		content_tag 'ul', breadcrumb.html_safe, :id => 'breadcrumb'
	end
	
private 
	
	def get_path
		
		if @path.nil? || @path == ''
			path = ' '
		else
			path = @path
			path.gsub! '/', '%3A'
		end
		
		path
	end
end
