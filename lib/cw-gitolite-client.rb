module Codewatch
	
	class GitException < Exception
	end
	
	
	class Repositories
		require 'gitolite'
		require 'timeout'
		require 'fileutils'
		
		@@lock_file_created = false
		
		def self.create_lock_file
			#TODO ensure that creates new only if none exist"
			if !@@lock_file_created
				@@lock_file_created = true
				Dir.chdir TMP_DIR
				File.new LOCK_FILE, "w"
				Dir.chdir Rails.root
			end
		end

		attr_reader :conf, :ga_repo

		TMP_DIR = "/tmp"
		GITOLITE_REPO_DIR = "/home/nobody/gitolite-admin"
		LOCK_FILE = "codewatch-gitolite.lock"

		def initialize
			Repositories.create_lock_file
			@ga_repo = Gitolite::GitoliteAdmin.new GITOLITE_REPO_DIR
			@conf = ga_repo.config
			nil
		end

		
		def create repo_name, string_key, user_name
			"""creates and push config to central gitolite repo"""
			ga_repo = git.ga_repo
			conf = git.conf
			
			repo = git.new_repo repo_name
			key = git.new_key string_key, user_name
			
			repo.add_permission "RW+","","#{user_name}"
			ga_repo.add_key key
			conf.add_repo repo
			ga_repo.save
		end
		

		
		def new_repo name
			Gitolite::Config::Repo.new name
		end

		def new_key key_string, user_name
			Gitolite::SSHKey.from_string key_string, user_name
		end


		def pull
			Dir.chdir(GITOLITE_REPO_DIR)
      `git pull`
			Dir.chdir(Rails.root)
    end

    def push
    	Dir.chdir(GITOLITE_REPO_DIR)
	    `git add -A`
      `git commit -am "codewatch"`
      `git push`
      Dir.chdir(Rails.root)
    end

    def configure
	    status = Timeout::timeout(20) do
		    File.open(File.join(TMP_DIR,LOCK_FILE), "w+") do |f|
			    begin 
            f.flock(File::LOCK_EX)
				    pull
            yield(self)
            push
          ensure
            f.flock(File::LOCK_UN)
          end
		    end
	    end
    end
  end
end   
#    rescue Exception => ex
# TODO logging
#      Gitlab::Logger.error(ex.message)
#	    raise Codewatch::GitException.new("Git: access denied - gitolite timeout")
 


