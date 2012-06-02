class Log < ActiveRecord::Base
	
	belongs_to :project
	belongs_to :user
	belongs_to :author, class_name: 'User', foreign_key: :author_id
	belongs_to :task
	
	class Type
		
		NEW_COMMIT = 1 
		TASK_ASSIGNMENT = 2
		DEPLOYMENT_FAILED = 3
	end
	
	def self.it type, project, author, options = {}
		
		log = self.new options
		log.ltype = type
		log.project = project
		log.author = author
		log.save!
	end
end
