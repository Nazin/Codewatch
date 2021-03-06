require 'server_connection'

class Server < ActiveRecord::Base

	attr_accessible :name, :localRepoPath, :stype, :host, :port, :remotePath, :username, :password, :revision, :autoUpdate, :state

	has_many :deployments
	belongs_to :project

	validates :name, presence: true, length: {maximum: 64}
	validates :stype, presence: true, inclusion: {in: 1..3}
	validates :host, presence: true, length: {maximum: 64}
	validates_numericality_of :port, :only_integer => true
	validates :username, presence: true, length: {maximum: 64}
	validates :password, presence: true, length: {maximum: 64}

	validate :test_connection
	validate :revision_validate
	validate :localpath_validate

	class Type

		FTP_PASSIVE = 1
		FTP_ACTIVE = 2
		SFTP_PASSWORD = 3

		def self.to_hash
			{
					'FTP Passive mode' => FTP_PASSIVE,
					'FTP Active mode' => FTP_ACTIVE,
					'SFTP password authorization' => SFTP_PASSWORD
			}
		end

		def self.to_list
			to_hash
		end
	end

	class State

		FINE = 1
		DEPLOYING = 2
		FAILED = 3

		def self.to_hash
			{
					'Fine' => FINE,
					'Deploying' => DEPLOYING,
					'Last deployment failed' => FAILED
			}
		end

		def self.to_list
			to_hash
		end
	end

	def deploy user

		if state != State::DEPLOYING

			@do_not_validate_connection = true

			@server = self
			@server.state = Server::State::DEPLOYING
			@server.save!

			spawn_block :method => :thread do

				repo = @server.project.repo

				head = repo.commits.first

				@deployment = Deployment.new
				@deployment.server = @server
				@deployment.user = user
				@deployment.revision = head.id

				if revision == ''
					if localRepoPath != ''
						tree = head.tree/localRepoPath
					else
						tree = head.tree
					end
					@deployment.filesTotal = tree_counter tree, 0
				else
					diff = improve_diff_to_local_path (Grit::Commit.diff repo, revision, head.id)
					@deployment.filesTotal = diff.length
				end

				@deployment.save!

				begin

					connection = start_connection

					if revision == ''
						tree_upload tree, connection
					else
						changes_upload diff, connection
					end

					connection.close

					@server.state = State::FINE
					@server.revision = head.id
				rescue Codewatch::HostUnreachable
					@deployment.state = Deployment::State::CONNECTION_PROBLEM
					@server.state = State::FAILED
				rescue Codewatch::PortUnreachable
					@deployment.state = Deployment::State::CONNECTION_PROBLEM
					@server.state = State::FAILED
				rescue Codewatch::WrongCredentials
					@deployment.state = Deployment::State::CONNECTION_PROBLEM
					@server.state = State::FAILED
				rescue Codewatch::PathNotAccessible => e
					@deployment.state = Deployment::State::ACCESSIBILITY_PROBLEM
					@deployment.info = e.message
					@server.state = State::FAILED
				rescue Codewatch::PathNotWritable => e
					@deployment.state = Deployment::State::WRITE_PROBLEM
					@deployment.info = e.message
					@server.state = State::FAILED
				rescue Exception => e
					@deployment.state = Deployment::State::CONNECTION_PROBLEM
					@server.state = State::FAILED
					@deployment.info = e.message
				end

				if @server.state == State::FAILED
					Log.it Log::Type::DEPLOYMENT_FAILED, @server.project, user
				end

				@deployment.finished = true
				@deployment.save!
				@server.save!
			end
		end
	end

	class ServerDiff
		attr_accessor :b_blob, :a_blob, :a_path, :b_path, :deleted_file, :new_file, :tree
	end

private

	def revision_validate

		if revision != ''

			repo = project.repo

			begin
				repo.commits revision
			rescue Exception
				errors[:revision] << " does not exist"
			end
		end
	end

	def localpath_validate

		if localRepoPath != ''

			repo = project.repo

			errors[:localRepoPath] << " does not exist" if (repo.tree/localRepoPath).nil?
		end
	end

	def test_connection

		if @do_not_validate_connection.nil?

			begin

				connection = start_connection

				connection.mkdir '___test___'
				connection.chdir '___test___'
				connection.put 'test.txt'
				connection.delete 'test.txt'
				connection.chdir '..'
				connection.rmdir '___test___'

				connection.close
			rescue Codewatch::HostUnreachable
				errors[:host] << " could not be reached"
			rescue Codewatch::PortUnreachable
				errors[:port] << " could not be reached"
			rescue Codewatch::WrongCredentials
				errors[:username] << " is wrong"
				errors[:password] << " is wrong"
			rescue Codewatch::PathNotAccessible
				errors[:remotePath] << " is not accessible"
			rescue Codewatch::PathNotWritable
				errors[:remotePath] << " is not writable"
			end
		end
	end

	def start_connection

		if [Type::FTP_PASSIVE, Type::FTP_ACTIVE].include? stype
			connection = Codewatch::FTPServerConnection.new host, port, username, password, stype
		elsif stype == Type::SFTP_PASSWORD
			connection = Codewatch::SFTPServerConnection.new host, port, username, password, stype
		end

		connection.open

		if remotePath != ''
			connection.chdir remotePath
		end

		connection
	end

	def tree_counter tree, elements

		for el in tree.contents

			if el.is_a? Grit::Tree
				elements = tree_counter el, elements
			else
				if not el.is_a? Grit::Submodule
					elements += 1
				end
			end
		end

		elements
	end

	def tree_upload tree, connection

		for el in tree.contents

			if el.is_a? Grit::Tree
				connection.mkdir el.name
				connection.chdir el.name
				tree_upload el, connection
				connection.chdir '..'
			else
				if not el.is_a? Grit::Submodule
					connection.put_binary el.name, el.data
					@deployment.filesProceeded += 1
					@deployment.save!
				end
			end
		end
	end

	def changes_upload diff, connection

		for el in diff

			if el.deleted_file
				changes_remove_single_file el.a_path, connection
			else

				if el.a_path != el.b_path
					changes_remove_single_file el.a_path, connection
					changes_upload_single_file el.b_path, (el.b_blob.nil? ? el.a_blob : el.b_blob), connection
				else
					changes_upload_single_file el.a_path, (el.b_blob.nil? ? el.a_blob : el.b_blob), connection
				end

			end

			@deployment.filesProceeded += 1
			@deployment.save!
		end
	end

	def changes_remove_single_file path, connection

		temp = File.join '.', path
		parts = temp.split File::SEPARATOR

		times = changes_jump_to_correct_directory path, connection

		connection.delete parts[parts.length-1]

		changes_jump_back path, times, connection
	end

	def changes_upload_single_file path, blob, connection

		temp = File.join '.', path
		parts = temp.split File::SEPARATOR

		times = changes_jump_to_correct_directory path, connection

		begin
			connection.delete parts[parts.length-1]
		rescue Codewatch::PathNotWritable
		end

		connection.put_binary parts[parts.length-1], blob.data

		changes_jump_back path, times, connection
	end

	def changes_jump_to_correct_directory path, connection

		i = 0
		temp = File.join '.', path
		parts = temp.split File::SEPARATOR

		if parts.length != 2

			for part in parts

				if part == '.' or part == parts[parts.length-1]
					next
				end

				begin
					connection.mkdir part
				rescue Codewatch::PathNotWritable
				end

				connection.chdir part
				i += 1
			end
		end

		i
	end

	def changes_jump_back path, times, connection

		if times > 0

			parts = path.split File::SEPARATOR

			while times > 0

				connection.chdir '..'
				times -= 1

				begin
					connection.rmdir parts[times]
				rescue Codewatch::PathNotWritable
				end
			end
		end
	end

	def improve_diff_to_local_path diff

		if localRepoPath != ''

			new_diff = []

			for el in diff

				if el.a_path =~ /^#{Regexp.escape(localRepoPath)}/

					temp = ServerDiff.new
					temp.a_blob = el.a_blob if not el.a_blob.nil?
					temp.b_blob = el.b_blob if not el.b_blob.nil?
					temp.deleted_file = el.deleted_file
					temp.a_path = el.a_path.gsub /^#{Regexp.escape(localRepoPath)}\/?\\?/, '' if not el.a_path.nil?
					temp.b_path = el.b_path.gsub /^#{Regexp.escape(localRepoPath)}\/?\\?/, '' if not el.b_path.nil?

					new_diff.push temp
				end
			end

			new_diff
		else
			diff
		end
	end
end
