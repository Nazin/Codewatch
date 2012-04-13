class UserController < ApplicationController


  def create
    #TODO FILL
  rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
    redirect_to home_url
  rescue ActionController::InvalidAuthenticityToken
    # Experience has shown that the vast majority of these are bots
    # trying to spam the system, so catch & log the exception.
    warning = "ActionController::InvalidAuthenticityToken: #{params.inspect}"
    #logger.warn warning
    redirect_to root_path
  end
	
	def signup
		
		if request.post?
			
			@user = User.new params[:signup][:user]
			@company = Company.new params[:signup][:company]
			
			 @user.valid?
			 @company.valid?
			
			if @user.valid? && @company.valid?
				
				#TODO: send mail
				#TODO: save models
			end
		else
			@user = User.new 
			@company = Company.new 
		end
	end

	def signin
	end
end
