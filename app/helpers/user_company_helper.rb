module UserCompanyHelper 

	#TODO not sure if it works
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
		#TODO @company ?? where does it come from?
		#HOW where does this instance ( @company) comes from?
		uc1 = UserCompany.where("company_id = ? and user_id = ?",@company.id, current_user.id).pluck(:role)
		uc1.first == role
	end





end
	
