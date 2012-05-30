require 'server_connection'

class Server < ActiveRecord::Base
	
	attr_accessible :name, :localRepoPath, :stype, :host, :port, :remotePath, :username, :password, :revision, :autoUpdate
	
	belongs_to :project
	
	validates :name, presence: true, length: {maximum: 64}
	validates :stype, presence: true, inclusion: { in: 1..3 }
	validates :host, presence: true, length: {maximum: 64}
	validates_numericality_of :port, :only_integer => true
	validates :username, presence: true, length: {maximum: 64}
	validates :password, presence: true, length: {maximum: 64}
	
	validate :test_connection
	
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
private
	
	def test_connection
		
		begin
		
			if [Type::FTP_PASSIVE, Type::FTP_ACTIVE].include? stype
				connection = Codewatch::FTPServerConnection.new host, port, username, password, stype
			elsif stype == Type::SFTP_PASSWORD
				connection = Codewatch::SFTPServerConnection.new host, port, username, password, stype
			end
			
			connection.open
			
			if remotePath != ''
				connection.chdir remotePath
			end 
			
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
