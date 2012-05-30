module Codewatch
	class Repositories
		require 'gitolite'

#		@pbatko = "/home/pbatko/gitolite-repo/gitolite-admin"

		
		attr_reader :conf

		def initialize
			ga_repo = Gitolite::GitoliteAdmin.new "/home/git/gitolite-admin"
			@conf = ga_repo.config
		end
		
		def new_repo name
			Gitolite::Config::Repo.new name
		end

		def new_key key_string, user_name
			Gitolite::SSHKey.from_string key_string, user_name
		end

	end
end

