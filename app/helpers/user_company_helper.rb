module UserCompanyHelper 
	
	def current_company= company
		@company = company
	end

	def company_owner?
		has_role? UserCompany::ROLE_OWNER
	end

	def company_admin?
		has_role? UserCompany::ROLE_ADMIN
	end

	def company_user?
		has_role? UserCompany::ROLE_USER
	end

	def company_spectator?
		has_role? UserCompany::ROLE_SPECTATOR
	end

private	

	def has_role? role
		
		uc1 = UserCompany.where("company_id = ? and user_id = ?", @company.id, current_user.id).pluck(:role)
		
		if uc1.first > role
			flash[:warning] = "You don't have access there"
			redirect_to dashboard_path
		end
	end
end
	
