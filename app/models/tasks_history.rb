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

  attr_accessible :state, :priority, :owner, :assigned_user

  belongs_to :task
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  belongs_to :assigned_user, class_name: 'User', foreign_key: :responsible_user_id

  validates :task, presence: true
  validates :owner, presence: true
  validates :assigned_user, presence: true

  validates :state, presence: true
  validates :priority, presence: true
end
