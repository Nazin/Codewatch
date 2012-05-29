class TasksHistory < ActiveRecord::Base
	belongs_to :task
	belongs_to :owner, class_name: 'User', foreign_key: :user_id
	belongs_to :assigned_user, class_name: 'User', foreign_key: :responsible_user_id

	validates :task, presence: true
	validates :owner, presence: true
	validates :assigned_user, presence: true
	
	validates :state, presence: true
	validates :priority, presence: true
	validates :posted, presence: true

	validate :priority_allowed_values
	validate :state_allowed_values

private

	def priority_allowed_values
		unless Task::Priority.to_list.include? priority
			errors.add :priority, " - illegal value"
		end
	end

	def state_allowed_values
		unless Task::State.to_list.include? state
			errors.add :state, " - illegal value"
		end
	end
end
