class Server < ActiveRecord::Base
	
	attr_accessible :name, :localRepoPath, :stype, :host, :port, :remotePath, :username, :password, :revision, :autoUpdate
	
	belongs_to :project
	
	validates :name, presence: true, length: {maximum: 64}
	validates :stype, presence: true, inclusion: { in: 1..3 }
	validates :host, presence: true, length: {maximum: 64}
	validates_numericality_of :port, :only_integer => true
	validates :username, presence: true, length: {maximum: 64}
	validates :password, presence: true, length: {maximum: 64}
	
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
end
