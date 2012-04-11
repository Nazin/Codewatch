class UserController < ApplicationController
	
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
