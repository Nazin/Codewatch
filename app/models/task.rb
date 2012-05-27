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
	belongs_to :user
	belongs_to :responsible_user, class_name: 'User', foreign_key: :responsible_user_id

	attr_accessible :title, :description, :state, :deadline, :responsible_user

	validates :title, presence: true, length: {maximum: 64}
	validates :user, presence: true
	validates :responsible_user, presence: true
	validates :project, presence: true
	validates :deadline, presence: true
	validates :posted, presence: true
#	validates :lang, presence: true, inclusion: { in: @@lexers }
#	validates :sha, presence: true


end