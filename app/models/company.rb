class Company < ActiveRecord::Base
	
	has_many :user_companies
	has_many :users, :through => :user_companies
	
	validates :name, presence: true, length: {maximum: 32, minimum: 3}, :uniqueness => true
	
	acts_as_url :name, :url_attribute => :slug
end