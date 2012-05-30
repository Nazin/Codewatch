class UsersController < ApplicationController

	before_filter :is_signed_in?, except: [:signin, :activate, :signup]
	before_filter :not_signed_in?, only: [:signin, :activate]
	before_filter :company_member?, only: [:index, :show, :invite, :destroy, :update]
	before_filter :company_owner?, only: [:invite, :destroy, :update]

	def index
		@users = @company.users
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
					
					redirect_to request.protocol + @invitation.company.slug + '.' + domain_parts[domain_parts.length-2] + '.' + domain_parts[domain_parts.length-1] + (request.port != 80? ":#{request.port}":'')
				end
			end
		end
		
		@user = User.new params[:user]

		if request.post?

			if @invitation.nil?
				@user.user_companies[0].role = UserCompany::Role::OWNER
			else
				company = @user.user_companies.build
				company.role = @invitation.role
				company.company = @invitation.company
			end
			
			action = @user.user_actions.build [atype: UserAction::Type::ACTIVATION]
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
		
		user_action = UserAction.find_by_key_and_isActive_and_atype params[:key], true, UserAction::Type::ACTIVATION
		
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
		@avatar = @user.avatar
	
		if request.put?

			if @user.update_attributes params[:user]
				flash[:success] = "Profile updated"
				sign_in @user
				redirect_to dashboard_path
			else
				flash.now[:warning] = "Invalid informations"
			end
		end
	end
	
	def remove_avatar
		
		FileUtils.remove_file File.join('public', 'upload', 'avatars', current_user.avatar), true
		
		current_user.avatar = nil
		current_user.save!
		
		flash[:success] = "Avatar removed"
		sign_in current_user
		redirect_to user_edit_path
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
	end
	
	def update
		
		@user = User.find params[:id]
		@user_company = UserCompany.find_by_user_id_and_company_id params[:id], @company.id
		
		if request.put? and @user_company.update_attributes params[:user_company]
			flash[:succes] = "User updated"
			redirect_to users_path
		elsif request.put?
			flash[:warning] = "Invalid information"
		end
	end
	
	def destroy
		user_company = UserCompany.find_by_user_id_and_company_id params[:id], @company.id
		user_company.destroy
		flash[:success] = "User removed from company"
		redirect_to users_path
	end
end
