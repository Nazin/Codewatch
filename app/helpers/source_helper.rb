module SourceHelper
	def tree el
		link_to el.name, project_tree_path(@project, el) 
	end

	def blob el
		lintk_to el.name, root_path
	end

end
