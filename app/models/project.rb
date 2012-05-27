class Project < ActiveRecord::Base
	
	TYPE_SVN = 1
	TYPE_GIT = 2
	
	belongs_to :company
	has_and_belongs_to_many :users
	
	attr_accessible :name, :ptype, :location, :user_ids
	validates :company_id, presence: true
	validates :location, presence: true, length: {maximum: 128 }
	validates :name, presence: true, length: {maximum: 32 }
	validates :ptype, presence: true, inclusion: { in: 1..2 }
end
