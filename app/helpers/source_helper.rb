module SourceHelper
	def tree el
		link_to el.name, project_tree_path(@project, el.id) 
	end

	def blob el
		link_to el.name, project_file_path(@project, el.id)
	end

end
