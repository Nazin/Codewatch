# == Schema Information
#
# Table name: tasks
#
#  id                  :integer         not null, primary key
#  title               :string(64)      not null
#  description         :text
#  posted              :datetime        not null
#  updated             :datetime
#  state               :integer(2)      not null
#  priority            :integer(2)      not null
#  deadline            :date
#  project_id          :integer         not null
#  milestone_id        :integer         not null
#  user_id             :integer         not null
#  responsible_user_id :integer         not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class Task < ActiveRecord::Base

	attr_accessible :title, :description, :state, :deadline, :assigned_user, :user_id, :priority, :responsible_user_id, :owner, :milestone_id
	
	belongs_to :project
	belongs_to :owner, class_name: 'User', foreign_key: :user_id
	belongs_to :assigned_user, class_name: 'User', foreign_key: :responsible_user_id
	belongs_to :milestone
	
	has_many :tasks_histories
	has_many :logs

	validates :priority, presence: true
	validates :title, presence: true, length: {maximum: 64}
	validates :owner, presence: true
	validates :assigned_user, presence: true
	validates :project, presence: true
	validates :milestone, presence: true
	validates :state, presence: true

	around_update :create_history_entry
		
	module State
		
		CLOSED = 1 #finished before deadline
		FAILED = 2 #not finished before deadline
		ACTIVE = 3 #in development, before deadline 

		def self.to_hash
			{
				'Closed' => CLOSED,
				'Failed' => FAILED,
				'Active' => ACTIVE
			}
		end
		
		def self.to_list
			to_hash
		end
	end

	module Priority
		
		CRITICAL = 1 
		IMPORTANT = 2
		NEUTRAL = 3
		NEGLIGIBLE = 4

		def self.to_hash
			{
				'Critical' => CRITICAL,
				'Important' => IMPORTANT,
				'Neutral' => NEUTRAL,
				'Negligible' => NEGLIGIBLE
			}
		end
		
		def self.to_list
			to_hash
		end
	end
private

	def create_history_entry
		
		history = nil
		
		if state != state_was or priority != priority_was or responsible_user_id_was != responsible_user_id
		
			history = tasks_histories.build state: state_was, priority: priority_was
			history.owner = User.find user_id_was
			history.assigned_user = User.find responsible_user_id_was
		end
			
		yield

		history.save if not history.nil?
	end
end
