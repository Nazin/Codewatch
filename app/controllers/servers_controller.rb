class ServersController < ApplicationController
	
	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	
	def index
		@servers = @project.servers
	end

	def new
		
		@server = @project.servers.build params[:server]
		
		if request.post? && @server.save
			flash[:succes] = "New server created"
			redirect_to project_servers_path
		elsif request.post?
			flash[:warning] = "Invalid information"
		end
	end

	def edit
		
		@server = Server.find params[:id]
		@server.deploy
		
		if request.put? and @server.update_attributes params[:server]
			flash[:succes] = "Server updated"
			redirect_to project_servers_path
		elsif request.put?
			flash[:warning] = "Invalid information"
		end
	end

	def destroy
		server = Server.find params[:id]
		server.destroy
		flash[:success] = "Server removed"
		redirect_to project_servers_path
	end
end
