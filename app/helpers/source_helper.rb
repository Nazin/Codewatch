module SourceHelper

	def tree el

		if @path.nil?
			path = el.name
		else
			path = File.join @path, el.name
			path.gsub! '/', '%2F'
		end

		link_to el.name, project_branch_tree_path(@project.id, @branch, path)
	end

	def blob el

		name = el.name
		
		if @path.nil?
			link_to name, project_branch_blob_path(@project.id, @branch, name)
		else
			@path.gsub! '/', '%2F'
			link_to name, project_parent_branch_blob_path(@project.id, @branch, @path, name)
		end
	end

	def up_dir

		parts = @path.reverse.split File::SEPARATOR, 2

		if parts.length == 2
			path = parts[1].reverse
			path.gsub! '/', '%2F'
		else
			path = ''
		end

		link_to '..', project_branch_tree_path(@project.id, @branch, path)
	end
end
