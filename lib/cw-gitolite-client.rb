module Codewatch
	class Repositories
		require 'gitolite'

		attr_reader :conf

		def initialize
			ga_repo = Gitolite::GitoliteAdmin.new "/home/git/repositories/gitolite-admin.git"
			@conf = ga_repo.config
		end
		

		

	end
end

