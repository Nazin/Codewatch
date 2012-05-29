# == Schema Information
#
# Table name: tasks_histories
#
#  id                  :integer         not null, primary key
#  state               :integer(2)      not null
#  priority            :integer(2)      not null
#  posted              :datetime        not null
#  task_id             :integer         not null
#  user_id             :integer         not null
#  responsible_user_id :integer         not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class TasksHistory < ActiveRecord::Base
	belongs_to :task
	belongs_to :owner, class_name: 'User', foreign_key: :user_id
	belongs_to :assigned_user, class_name: 'User', foreign_key: :responsible_user_id

	attr_accessible :state, :priority, :posted, :owner, :assigned_user

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
