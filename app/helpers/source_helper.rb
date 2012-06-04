module SourceHelper
	def tree el
		link_to el.name, project_tree_path(@project, el.id) 
	end

	def blob el, parent_id=nil
		if parent_id.nil?
			link_to el.name, project_blob_path(@project, el.id)
		else
			link_to el.name, project_parent_blob_path(@project, parent_id, el.id)
		end
	end

end
