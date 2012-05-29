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
	
	attr_accessible :name, :mail , :password, :password_confirmation, :user_companies_attributes, :fullName, :avatar
	attr_accessor :updating_password
	
	before_save :create_remember_token
	has_secure_password	

	has_many :user_companies
	has_many :user_actions
	has_many :companies, through: :user_companies
	has_many :tasks
	has_many :responsible_tasks, class_name: 'Task', foreign_key: :responsible_user_id
	has_many :tasks_histories
	has_and_belongs_to_many  :projects
	accepts_nested_attributes_for :user_companies, :user_actions

	validates :mail, presence: true, length: {maximum: 64}, uniqueness: {case_sensitive: false}, email: {strict_mode: true}
	validates :name, presence: true, length: {maximum: 32, minimum: 3}
	validates :password, presence: true, length: {minimum: 6}, if: :should_validate_password?
	validates :password_confirmation, presence: true, if: :should_validate_password?
	validate :avatar_validation, if: "avatar?"
			
	before_update :avatar_upload
private

	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end

	def should_validate_password?
		updating_password || new_record?
	end
	
	def avatar_upload

		if not avatar.nil? and not avatar.is_a?(String)
			
			if not avatar_was.nil?
				FileUtils.remove_file File.join('public', 'upload', 'avatars', avatar_was), true
			end
			
			name_parts = avatar.original_filename.split '.'

			file = File.join 'public', 'upload', 'avatars', id.to_s + '.' + name_parts[name_parts.length-1]
			FileUtils.cp_r avatar.tempfile.path, file

			require 'rmagick'

			image = Magick::Image::read(file).first
			image.resize_to_fill! 50
			image.write file
			image.destroy!

			self.avatar = id.to_s + '.' + name_parts[name_parts.length-1]
		end
	end
	
	def avatar_validation
		errors[:avatar] << "should be image" if not avatar.nil? and not avatar.is_a?(String) and not ['image/jpeg', 'image/png', 'image/gif'].include? avatar.content_type
	end
end
