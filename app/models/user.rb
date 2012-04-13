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
#

# require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :user_companies
	has_many :companies, through: :user_companies
	
  attr_accessible :name, :mail , :password, :password_confirmation
  has_secure_password	

	validates :mail, presence: true, length: {maximum: 64}, uniqueness: {case_sensitive: false}, email: {strict_mode: true}
	validates :name, presence: true, length: {maximum: 32, minimum: 3}
  validates :password, presence: true, length: {minimum: 6}
	validates :password_confirmation, presence: true


end
