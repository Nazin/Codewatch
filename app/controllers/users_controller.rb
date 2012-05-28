class UsersController < ApplicationController
	
	before_filter :can_access_company, only: [:index, :show, :invite]
	before_filter :is_guest, only: [:signin, :activate]
	before_filter :is_signed_in, only: [:signout]
	before_filter :company_owner?, only: [:invite]

	def index
		@users = @company.users.paginate page: params[:page]
	end
	
	def signup
		
		if not params[:key].nil?
			
			@invitation = Invitation.find_by_key_and_isActive params[:key], true
			
			if @invitation.nil?
				redirect_to signup_path
			else
				
				user = User.find_by_mail @invitation.mail
				
				if not user.nil?
				
					company = user.user_companies.build
					company.role = @invitation.role
					company.company = @invitation.company
					company.save
					
					@invitation.isActive = false
					@invitation.save
					
					flash[:success] = "You have accepted invitation"
					
					domain_parts = request.host.split('.')
					
					redirect_to request.protocol + @invitation.company.slug + '.' + domain_parts[domain_parts.length-2] + '.' + domain_parts[domain_parts.length-1] + (request.port != 80?":#{request.port}":'')
				end
			end
		end
		
		@user = User.new params[:user]

		if request.post?

			if @invitation.nil?
				@user.user_companies[0].role = UserCompany::ROLE_OWNER
			else
				company = @user.user_companies.build
				company.role = @invitation.role
				company.company = @invitation.company
			end
			
			action = @user.user_actions.build [atype: UserAction::TYPE_ACTIVATION]
			key = action[0].generate_key
			
			if @user.save
				
				if not @invitation.nil?
					@invitation.isActive = false
					@invitation.save
				end
				
				flash[:success] = "Before you can login, you must active your account with the code sent to your email address."
				UserMailer.activate_email(@user, key).deliver
				
				redirect_to root_path
			else
				flash[:warning] = "Invalid informations"
			end
		else
			user_companies = @user.user_companies.build
			user_companies.build_company
		end 
	end

	def signin
		
		if request.post?
			
			user = User.find_by_mail params[:session][:mail]
			authenticated = user && user.authenticate(params[:session][:password])
			
			if user && authenticated && user.isActive
				
				sign_in user
				domain_parts = request.host.split('.')
				
				if domain_parts.length > 2
					redirect_back_or_to dashboard_path
				else
					redirect_to request.protocol + user.companies[0].slug + '.' + domain_parts[domain_parts.length-2] + '.' + domain_parts[domain_parts.length-1] + (request.port != 80? ":#{request.port}":'')
				end
			elsif user && authenticated && !user.isActive
				flash.now[:error] = 'Account is inactive. Please check your inbox for activation link'
			elsif user && !authenticated
				flash.now[:error] = 'Invalid password given'
			else
				flash.now[:error] = 'No user with this email address'
			end
		end
	end
	
	def signout
		sign_out
		redirect_home
	end
	
	def activate 
		
		user_action = UserAction.find_by_key_and_isActive_and_atype params[:key], true, UserAction::TYPE_ACTIVATION
		
		if user_action
			
			user_action.user.isActive = true
			user_action.isActive = false
			user_action.save :validate => false
			
			flash[:success] = "Your account has been activated, you can now sign in."
			UserMailer.welcome_email(user_action.user).deliver
		else
			flash[:warning] = "Given key is wrong"
		end
		
		redirect_to root_path
	end
	
	def show
		
		@user = User.find params[:id]
		
		if not @company.users.include?(@user)
			flash[:warning] = "You don't have access to that's user profile"
			redirect_to dashboard_path
		end
	end

	def edit
		
		@user = current_user
	
		if request.put?

			if @user.update_attributes params[:user] #todo nie sprawdzanie hasel - osobny formularz do hasel, uploader obrazkow
				flash[:success] = "Profile updated"
				sign_in @user
				redirect_to dashboard_path
			else
				flash[:warning] = "#{@user.errors}a Invalid #{params[:user]} informations #{@user.inspect}"
			end
		end
	end
	
	def invite
		
		@invitation = @company.invitations.build params[:invitation]
		
		if request.post? and @invitation.valid?
		
			user = User.find_by_mail params[:invitation][:mail]
			invitation = Invitation.find_by_mail params[:invitation][:mail]
			
			if not user.nil? and user.companies.include? @company
				flash.now[:warning] = "User already belongs to this company"
			else
				if not invitation.nil?
					flash.now[:warning] = "User has already been invited"
				else

					key = @invitation.generate_key
					@invitation.save

					UserMailer.invite_email(params[:invitation][:mail], @company, key).deliver
					
					flash[:success] = "User invited"
					redirect_to users_path
				end			
			end
		end
		
		@roles = {'Select' => 0, 'Owner' => UserCompany::ROLE_OWNER, 'Admin' => UserCompany::ROLE_ADMIN, 'User' => UserCompany::ROLE_USER, 'Spectactor' => UserCompany::ROLE_SPECTATOR}
	end
end
