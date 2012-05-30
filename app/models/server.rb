require 'net/ftp'
require 'net/sftp'

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
				test_ftp_connection
			elsif stype == Type::SFTP_PASSWORD
				test_sftp_connection
			end
		rescue SocketError
			errors[:host] << " could not be reached"
		rescue Errno::ECONNREFUSED
			errors[:port] << " could not be reached"
		rescue Exception => e
			errors[:host] << " could not be connected"
		end
	end
	
	def test_sftp_connection
		
		begin
			
			Net::SFTP.start host, username, :password => password, :port => port do |sftp|
				
				test_dir = '___test___'
				
				if remotePath != ''
					sftp.opendir! remotePath					
					test_dir = File.join remotePath, '___test___'
				end
				
				sftp.mkdir! test_dir
				sftp.upload! "test.txt", (File.join test_dir, "test.txt")
				sftp.remove! (File.join test_dir, "test.txt")
				sftp.rmdir! test_dir
			end
		rescue Net::SSH::AuthenticationFailed
			errors[:username] << " is wrong"
			errors[:password] << " is wrong"
		rescue Net::SFTP::StatusException => e
			
			if e.message =~ /permission denied/
				errors[:remotePath] << " is not writable"
			else
				errors[:remotePath] << e.message
			end
		end
	end
	
	def test_ftp_connection
		
		begin
			
			ftp = Net::FTP.new
			
			ftp.passive = stype == Type::FTP_PASSIVE
			ftp.binary = true
			
			ftp.connect host, port
			ftp.login username, password
			
			if remotePath != ''
				ftp.chdir remotePath
			end 
			
			ftp.mkdir '___test___'
			ftp.chdir '___test___'
			ftp.put "test.txt"
			ftp.delete "test.txt"
			ftp.chdir '..'
			ftp.rmdir '___test___'
			
			ftp.quit()
		rescue Net::FTPPermError => e
			
			if e.message =~ /530/
				errors[:username] << " is wrong"
				errors[:password] << " is wrong"
			elsif e.message =~ /550 Failed to change directory/
				errors[:remotePath] << " is unreachable"
			elsif e.message =~ /550 Create directory operation failed/
				errors[:remotePath] << " is not writable"
			else
				errors[:remotePath] << e.message
			end
		end
	end
end
