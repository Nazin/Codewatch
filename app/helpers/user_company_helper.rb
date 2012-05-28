module UserCompanyHelper 
	
	def current_company= company
		@company = company
	end

	def company_owner?
		has_role? UserCompany::ROLE_OWNER, true
	end

	def company_admin?
		has_role? UserCompany::ROLE_ADMIN, true
	end

	def company_user?
		has_role? UserCompany::ROLE_USER, true
	end

	def company_spectator?
		has_role? UserCompany::ROLE_SPECTATOR, true
	end
private	

	def has_role? role, redirect
		
		uc1 = UserCompany.where("company_id = ? and user_id = ?", @company.id, current_user.id).pluck(:role)
		
		if uc1.first > role and redirect
			flash[:warning] = "You don't have access there"
			redirect_to dashboard_path
		end
		
		uc1.first <= role
	end
end
	
