# -*- coding: utf-8 -*-
class UsersController < ApplicationController
	
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: :destroy
	before_filter :registered_user, only: [:new, :create]
	
	def index
		@users = User.paginate page: params[:page]
	end
	
	def signup
		
		@user = User.new params[:user]

		if request.post?

			@user.user_companies[0].role = UserCompany::ROLE_OWNER
			
			@user.user_actions.build
			@user.user_actions[0].atype = UserAction::TYPE_ACTIVATION
			key = @user.user_actions[0].generate_key
			
			if @user.save
				
				flash[:success] = "Before you can login, you must active your account with the code sent to your email address."
				
				url = url_for :controller => 'users', :action => 'activate', :key => key
				
				mail(@user.mail, @user.name, 'Account activation', '<p>Hi there,</p><p>You’re nearly done!</p><p>We just need you to activate your account.</p><p>To insure our future messages reach you please add us to your address book.</p><p>To activate your account please click the link below:</p><a href="' + url + '">' + url + '</a>')
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
			#TODO moze wysylanie jakiegos maila witajacego
		else
			flash[:warning] = "Given key is wrong"
		end
		
		redirect_to root_path
	end
	
	def show
		
		@user = User.find params[:id]
		@user_companies = @user.user_companies
		
		rescue ActiveRecord::StatementInvalid
		# Handle duplicate email addresses gracefully by redirecting.
		redirect_to root_path
		rescue ActionController::InvalidAuthenticityToken
		# Experience has shown that the vast majority of these are bots
		# trying to spam the system, so catch & log the exception.
		#warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
		#logger.warn warning
		redirect_to root_path
	end

	def edit
	end

	def update
		
		if @user.update_attributes params[:user]
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			flash.now[:warning] =	 "Invalid informations"
			render 'edit'
		end
	end

	def destroy
		@user.destroy
		flash[:success] = "User destroyed."
		redirect_to users_path
	end


private

	
	def signed_in_user
		unless signed_in?
			store_location
			redirect_to signin_path, notice: "Please sign in" 
		end
	end

	def correct_user
		@user = User.find params[:id]
		redirect_to root_path unless current_user? @user
	end

	def admin_user
		@user = User.find params[:id]
		redirect_to root_path unless current_user.admin? && !(current_user? @user)
	end

	def registered_user
		redirect_to root_path, notice: "You already have an account" if signed_in?
	end
end
