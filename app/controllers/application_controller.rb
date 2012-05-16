class ApplicationController < ActionController::Base
	
	before_filter :check_company
	
	protect_from_forgery
	include SessionsHelper
	
private
	
	def check_company
		
		domain_parts = request.host.split('.')
		
		if domain_parts.length == 3
			
			@company = Company.find_by_slug domain_parts[0]
			
			if @company.nil?
				flash[:warning] = "Given url is not correct"
				redirect_home
			end
		else
			@company = nil
		end
	end
	
	def is_signed_in
		unless signed_in?
			store_location
			redirect_to signin_path, notice: "Please sign in" 
		end
	end
	
	def is_guest
		redirect_to root_path, notice: "You already have an account" if signed_in?
	end
	
	def can_access_company
		is_signed_in
		if not @company.users.include?(@current_user)
			flash[:warning] = "You don't have access to that company"
			redirect_home
		end
	end
	
	def redirect_home
		
		domain_parts = request.host.split('.')
		
		if domain_parts.length > 2
			redirect_to request.protocol + domain_parts[domain_parts.length-2] + '.' + domain_parts[domain_parts.length-1] + (request.port != 80?":#{request.port}":'')
		else
			redirect_to root_path
		end
	end
end
