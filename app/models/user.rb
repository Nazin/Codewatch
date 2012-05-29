# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  mail            :string(64)      not null
#  name            :string(32)      not null
#  fullName        :string(64)
#  havePicture     :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  isActive        :boolean         default(FALSE)
#

# require 'digest/sha1'

class User < ActiveRecord::Base
	
	attr_accessible :name, :mail , :password, :password_confirmation, :user_companies_attributes
	
	before_save :create_remember_token
	has_secure_password	

	has_many :user_companies
	has_many :user_actions
	has_many :companies, through: :user_companies
	has_many :owned_tasks, class_name: 'Task', foreign_key: :user_id
	has_many :assigned_tasks, class_name: 'Task', foreign_key: :responsible_user_id
	has_many :owned_tasks_histories, class_name: 'TasksHistory', foreign_key: :user_id
	has_many :assigned_tasks_histories, class_name: 'TasksHistory', foreign_key: :responsible_user_id



	has_and_belongs_to_many  :projects

	accepts_nested_attributes_for :user_companies, :user_actions

	validates :mail, presence: true, length: {maximum: 64}, uniqueness: {case_sensitive: false}, email: {strict_mode: true}
	validates :name, presence: true, length: {maximum: 32, minimum: 3}
	validates :password, presence: true, length: {minimum: 6}, if: :should_validate_password?
	validates :password_confirmation, presence: true, if: :should_validate_password?

	attr_accessor :updating_password
private

	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end

	def should_validate_password?
		updating_password || new_record?
	end
end
