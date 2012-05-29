# == Schema Information
#
# Table name: user_companies
#
#	 id					:integer				 not null, primary key
#	 user_id		:integer				 not null
#	 company_id :integer				 not null
#	 role				:integer(2)			 not null
#

class UserCompany < ActiveRecord::Base
	
	attr_accessible :role, :company_attributes
	
	ROLE_OWNER = 1
	ROLE_ADMIN = 2
	ROLE_USER = 3
	ROLE_SPECTATOR = 4
	
	belongs_to :user
	belongs_to :company
	accepts_nested_attributes_for :company
	
	validates :role, presence: true, inclusion: { in: 1..4 }
end
