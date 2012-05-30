module Codewatch
	class Repositories
		require 'gitolite'

#		@pbatko = "/home/pbatko/gitolite-repo/gitolite-admin"
		@cw ="/home/git/repositories/gitolite-admin.git"
		
		attr_reader :conf

		def initialize
			ga_repo = Gitolite::GitoliteAdmin.new "/home/git/gitolite-admin"
			@conf = ga_repo.config
		end
		

		

	end
end

