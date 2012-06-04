module SourceHelper
	def tree el
		link_to el.name, project_tree_path(@project, el.id) 
	end

	def blob el
		link_to el.name, project_blob_path(@project, el.id)
	end

end
