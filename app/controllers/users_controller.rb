class UsersController < ApplicationController
	
	before_filter :can_access_company, only: [:index, :show]
	before_filter :is_guest, only: [:signup, :signin, :activate]
	before_filter :is_signed_in, only: [:signout]

	def index
		@users = @company.users.paginate page: params[:page]
	end
	
	def signup
		
		@user = User.new params[:user]

		if request.post?
			#TODO weird syntax and why zeroth?
			# [0] ??
			# what about this:
			# user_company = @user.user_companies.build role: role
			# user_company.company = @company
			@user.user_companies[0].role = UserCompany::ROLE_OWNER
			
			@user.user_actions.build
			@user.user_actions[0].atype = UserAction::TYPE_ACTIVATION
			key = @user.user_actions[0].generate_key
			
			if @user.save
				
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
				redirect_back_or_to user
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
		redirect_to root_path
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
				flash[:warning] = "Invalid informations"
			end
		end
	end
end
