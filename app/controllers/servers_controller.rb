class ServersController < ApplicationController
	
	before_filter :company_member?
	before_filter :company_admin?, only: [:new, :edit, :destroy]
	
	def index
		@servers = @project.servers
		@deployments = Deployment.order("created_at desc").limit(10).joins(:server).find_all_by_server_id @servers
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
		
		if request.put? and @server.update_attributes params[:server]
			flash[:succes] = "Server updated"
			redirect_to project_servers_path
		elsif request.put?
			flash[:warning] = "Invalid information"
		end
	end

	def deploy
		
		@server = Server.find params[:id]
		
		if @server.state == Server::State::DEPLOYING
			flash[:succes] = "Server is deploying at the moment"
		else
			flash[:succes] = "Server deployed"
			@server.deploy
		end
		
		redirect_to project_servers_path
	end
	
	def destroy
		server = Server.find params[:id]
		server.destroy
		flash[:success] = "Server removed"
		redirect_to project_servers_path
	end
end
