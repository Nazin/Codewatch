# == Schema Information
#
# Table name: tasks
#
#  id                  :integer         not null, primary key
#  title               :string(64)      not null
#  description         :text
#  posted              :datetime
#  updated             :datetime
#  state               :integer(2)      not null
#  deadline            :date            not null
#  project_id          :integer         not null
#  user_id             :integer         not null
#  responsible_user_id :integer         not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class Task < ActiveRecord::Base

	belongs_to :project
	belongs_to :owner, class_name: 'User', foreign_key: :user_id
	belongs_to :assigned_user, class_name: 'User', foreign_key: :responsible_user_id
	has_many :tasks_histories

	attr_accessible :title, :description, :state, :deadline, :assigned_user, :user_id, :priority, :responsible_user_id, :owner

	validates :priority, presence: true
	validates :title, presence: true, length: {maximum: 64}
	validates :owner, presence: true
	validates :assigned_user, presence: true
	validates :project, presence: true
	validates :deadline, presence: true
	validates :posted, presence: true

		
	module State
		CLOSED = 1 #finished before deadline
		FAILED = 2 #not finished before deadline
		ACTIVE = 3 #in development, before deadline 

		def self.to_hash
			{CLOSED => 'CLOSED',
				FAILED => 'FAILED',
				ACTIVE =>  'ACTIVE'}
		end
		
		def self.to_list
			to_hash.keys
		end


	end

	module Priority
		CRITICAL = 1 
		IMPORTANT = 2
		NEUTRAL = 3
		NEGLIGIBLE = 4

		def self.to_hash
			{CRITICAL => 'CRITICAL', 
				IMPORTANT => 'IMPORTANT',
				NEUTRAL => 'NEUTRAL',
				NEGLIGIBLE => 'NEGLIGIBLE'}
		end
		
		def self.to_list
			to_hash.keys
		end

	end


end
