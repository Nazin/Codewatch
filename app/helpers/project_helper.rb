module ProjectHelper
	def repo_info project
		if project.repository_created
			"Your repository address: git@codewatch.pl:#{project.location}.git"
		else
			link_to "Create git repository", create_project_repo_path(project)
		end
	end

end
