module ProjectHelper

	def repo_info project

		domain_parts = request.host.split('.')

		if project.repository_created
			"Your repository address: git@#{domain_parts[domain_parts.length-2]}.#{domain_parts[domain_parts.length-1]}:#{project.location}.git"
		else
			link_to "Try again: Create git repository", create_project_repo_path(project), class: 'button r'
		end
	end
end
