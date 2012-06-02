# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(32)      not null
#  ptype      :integer(2)      not null
#  location   :string(128)     not null
#  company_id :integer         not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Project < ActiveRecord::Base
	
	attr_accessible :name, :ptype, :user_ids, :slug
	
	TYPE_SVN = 1
	TYPE_GIT = 2
	
	belongs_to :company
	has_and_belongs_to_many :users
	has_many :tasks
	has_many :servers
	has_many :milestones
	has_many :logs

	validates :user_ids, presence: true
	validates :company_id, presence: true
	validates :location, presence: true, length: {maximum: 128 }
	validates :name, presence: true, length: {maximum: 32 }
	validates :ptype, presence: true, inclusion: { in: 1..2 }
	
	#TODO test this validator
	validates :name, presence: true, uniqueness: { scope: :company_id }
	
	acts_as_url :name, :url_attribute => :slug
	
	def repo
		Grit::Repo.new repo_location
	end
	
	def repo_location
		#TODO ladna konfigurowalna sciezka
		'/home/git/repositories/' + location + '.git'
	end
	
	def self.commit_received id, revision
		
		project = self.find id
		
		repo = project.repo
		commits = repo.commits revision
		newest_commit = commits.first
		
		author = User.find_by_mail newest_commit.author.email
		
		Log.it Log::Type::NEW_COMMIT, project, author, {:revision => revision, :message => newest_commit.message}
		
		project.servers.each do |server|
			if server.autoUpdate
				server.deploy author
			end
		end
	end
end
