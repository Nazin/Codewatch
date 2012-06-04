module SourceHelper
	def tree el
		link_to el.name, project_tree_path(@project, el.id) 
	end

	def blob el, parent=nil
		if parent.nil?
			link_to el.name, project_blob_path(@project, el.id)
		else
			link_to el.name, project_parent_blob_path(@project, parent, el.id)
		end
	end

end
