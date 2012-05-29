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
	
	belongs_to :user
	belongs_to :company
	accepts_nested_attributes_for :company
	
	validates :role, presence: true, inclusion: { in: 1..4 }

	class Role
		
		OWNER = 1
		ADMIN = 2
		USER = 3
		SPECTATOR = 4

		def self.to_hash
			{
				'Owner' => OWNER,
				'Admin' => ADMIN,
				'User' => USER,
				'Spectactor' => SPECTATOR
			}
		end
		
		def self.to_list
			to_hash
		end

		def initialize company, user
			@company, @user = company, user
		end

		def owner? redirect=true
			has_role? OWNER, redirect
		end
		
		def admin? redirect=true
			has_role? ADMIN, redirect
		end
		
		def user? redirect=true
			has_role? USER, redirect
		end
		
		def spectator? redirect=true
			has_role? SPECTATOR, redirect
		end
		
		private	
		
		def has_role? role, redirect=true
			
			uc1 = UserCompany.where("company_id = ? and user_id = ?", @company.id, @user.id).pluck(:role)
			
			if uc1.first > role and redirect
				flash[:warning] = "You don't have access there"
				redirect_to dashboard_path
			end
			
			uc1.first <= role
		end
	end
end
