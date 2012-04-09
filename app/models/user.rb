require 'digest/sha1'

class User < ActiveRecord::Base
	
	has_many :user_companies
	has_many :companies, :through => :user_companies
	
	validates :mail, presence: true, length: {maximum: 64}, :uniqueness => true, :email => {:strict_mode => true}
	validates :name, presence: true, length: {maximum: 32, minimum: 3}
	validates :password, presence: true, length: {minimum: 6}
	validates :password_confirmation, presence: true, length: {minimum: 6}
	
	attr_accessor :password, :password_confirmation
	
	def password=(pass)
		self.passSalt = User.random_string(5)
		self.passHash = User.encrypt(pass, self.passSalt)
	end
	
	def self.encrypt(password, salt)
		Digest::SHA1.hexdigest(salt + password + salt)
	end
	
	def self.random_string(len)
		
		newstring = ""
		
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		1.upto(len) { |i| newstring << chars[rand(chars.size-1)] }
	
		newstring
	end
end
