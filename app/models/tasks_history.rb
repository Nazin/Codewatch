class TasksHistory < ActiveRecord::Base
	belongs_to :task
	belongs_to :user
	belongs_to :responsible_user, class_name: 'User', foreign_key: :responsible_user_id
end
