module ProjectHelper
	def repo_info project
		"Your repository address: git@codewatch.pl:#{project.location}.git"
	end

end
