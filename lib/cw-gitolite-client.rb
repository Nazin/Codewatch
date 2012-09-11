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
      "" "creates and push config to central gitolite repo" ""
      repo = new_repo repo_name
      key = new_key string_key, user_name

      repo.add_permission "RW+", "", "#{user_name}"
      ga_repo.add_key key
      conf.add_repo repo
      ga_repo.save
    end


    def set_permission repo_name, user_name, perm_string
      repo = conf.get_repo repo_name
      repo.clean_permissions
#			repo = Gitolite::Config::Repo.new repo_name
      repo.add_permission(perm_string, "", user_name)
      conf.add_repo repo, true
      ga_repo.save
    end


    def destroy_repo project
      FileUtils.rm_rf(project.repo_location)
      conf.rm_repo(project.location)
      ga_repo.save
    end

    def set_project_permissions project
      admins = project.owners.all
      admins += project.admins.all
      writers = project.writers.all
      readers = project.spectators.all

      repo_name = project.location
      repo = conf.get_repo repo_name
      repo.clean_permissions

      admins = names_with_public_key admins
      writers = names_with_public_key writers
      readers = names_with_public_key readers
      unless admins.empty?
        repo.add_permission("RW+", "", admins)
      end
      unless writers.empty?
        repo.add_permission("RW", "", writers)
      end
      unless readers.empty?
        repo.add_permission("R", "", readers)
      end
      conf.add_repo repo, true
      ga_repo.save
    end

    def names_with_public_key users
      with_key = users.find_all do |u|
        !u.public_key.blank?
      end
      with_key.map { |u| u.mail }
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
        File.open(File.join(TMP_DIR, LOCK_FILE), "w+") do |f|
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
 


