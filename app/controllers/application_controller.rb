class ApplicationController < ActionController::Base

	require 'cw-gitolite-client'

	before_filter :inspect_url_for_company # provides @company field

	protect_from_forgery

	include SessionsHelper

	private

	def get_page
		
		page = params[:page]
		if page.nil?
			page = 1 
		else
			page = page.to_i
		end
		
		page
	end
	
	def update_repo_perms

		begin
			Codewatch::Repositories.new.configure do |git| # provides 20s timeout
				git.set_project_permissions @project
			end
		rescue Exception => e
			flash[:error] = "Set repository permissions error #{e.inspect}"
		end
	end

	def create_repo

		repo_name = @project.location
		string_key = current_user.public_key
		user_name = current_user.mail

		begin
			Codewatch::Repositories.new.configure do |git| # provides 20s
				git.create repo_name, string_key, user_name
			end
		rescue
			flash[:error] = "Repository creation error"
			return
		end

		when_repo_created_action
	end

	def when_repo_created_action

		hook_location = @project.repo_location + '/hooks/post-receive'
		new_hook = File.new hook_location, 'w+'

		hook_template = File.open 'post-receive.hook.sample', 'r'
		hook_template.each do |line|
			new_hook.puts (line.gsub 'PROJECT_ID', @project.id.to_s)
		end

		new_hook.close
		hook_template.close

		File.chmod 0777, hook_location

		@project.repository_created = true
		if @project.save
			flash[:notice] = "New repository created"
		else
			flash[:error] = "New repository created, but something unsuspected happened"
		end
	end

	def inspect_url_for_company

		domain_parts = request.host.split('.')

		@home = request.protocol + domain_parts[domain_parts.length-2] + '.' + domain_parts[domain_parts.length-1] + (request.port != 80 ? ":#{request.port}" : '')

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
