class ApplicationController < ActionController::Base
	require 'cw-gitolite-client'
	
	before_filter :inspect_url_for_company # provides @company field
	
	protect_from_forgery

	include SessionsHelper

private

	
	def update_repo_perms
		repo_name = @project.location
		string_key = current_user.public_key
		user_name = current_user.name
		begin
			Codewatch::Repositories.new.configure do |git| # provides 20s timeout
				git.create repo_name, string_key, user_name
			end
		rescue
			flash[:error]="Set repository permissions error"
		end
		
	end

	
	def inspect_url_for_company
		
		domain_parts = request.host.split('.')
		
		if domain_parts.length == 3
			
			@company = Company.find_by_slug domain_parts[0]
			
			if @company.nil?
				flash[:warning] = "Given url is not correct"
				redirect_home
			end
			
			if not params[:project_id].nil?
				@project = Project.find_by_id params[:project_id]
			end
		else
			@company = nil
		end
		
		@home = request.protocol + domain_parts[domain_parts.length-2] + '.' + domain_parts[domain_parts.length-1] + (request.port != 80? ":#{request.port}":'')
	end
	
	def is_signed_in?
		unless signed_in?
			store_location
			redirect_to signin_path, notice: "Please sign in"
		end
		signed_in?
	end
	
	def not_signed_in?
		redirect_to root_path, notice: "You have already singed in" if signed_in?
	end
		
	def company_member?
		unless @company.users.include?(current_user)
			flash[:warning] = "You don't have access to that company"
			redirect_home
		end
	end

	def company_owner?
		role = UserCompany::Role.new @company, current_user
		unless role.owner?
			flash[:warning] = "You don't have access there"
			redirect_to dashboard_path
		end
	end
	
	def company_admin?
		role = UserCompany::Role.new @company, current_user
		unless role.admin?
			flash[:warning] = "You don't have access there"
			redirect_to dashboard_path
		end
	end

	def redirect_home
		domain_parts = request.host.split('.')
		if domain_parts.length > 2
			redirect_to @home
		else
			redirect_to root_path
		end
	end
end
