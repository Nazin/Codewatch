class PageController < ApplicationController

	def home

		if not @company.nil?
			redirect_to dashboard_path
		end
	end

	def help
	end
end
