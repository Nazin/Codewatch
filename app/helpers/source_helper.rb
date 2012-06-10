module SourceHelper
	
	def tree el
		
		if @path.nil?
			path = el.name
		else
			path = File.join @path, el.name
		end
		
		path.gsub! '/','_'

		link_to el.name, project_tree_path(@project, path)
	end

	def blob el
		
		if @path.nil?
			link_to el.name, project_blob_path(@project, el.id)
		else
			@path.gsub! '/','_'
			link_to el.name, project_parent_blob_path(@project, @path, el.id)
		end
	end
	
	def up_dir
	
		parts = @path.reverse.split File::SEPARATOR, 2
					
		if parts.length == 2
			path = parts[1].reverse
		else
			path = ''
		end
		
		link_to '..', project_tree_path(@project, path)
	end
end
