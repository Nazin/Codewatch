class Log < ActiveRecord::Base

	belongs_to :project
	belongs_to :user
	belongs_to :author, class_name: 'User', foreign_key: :author_id
	belongs_to :task

	class Type

		NEW_COMMIT = 1
		TASK_ASSIGNMENT = 2
		DEPLOYMENT_FAILED = 3
		NEW_CODE_COMMENT = 4
		NEW_COMMENT_COMMENT = 5

		def self.to_hash
			{
					'Commits' => NEW_COMMIT,
					'Tasks' => TASK_ASSIGNMENT,
					'Deployments' => DEPLOYMENT_FAILED,
					'Code review' => NEW_CODE_COMMENT,
					'Comments' => NEW_COMMENT_COMMENT
			}
		end

		def self.to_list
			to_hash
		end
	end

	def self.it type, project, author, options = {}

		log = self.new options
		log.ltype = type
		log.project = project
		log.author = author
		log.save!
	end
end
