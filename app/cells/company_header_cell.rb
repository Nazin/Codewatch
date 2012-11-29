class CompanyHeaderCell < UnauthorizedUserHeaderCell

	helper SessionsHelper

	def display args
		
		@company = args[:company]
		@project = args[:project]
		@admin = args[:admin]
		
		@host = request.host.sub "#{@company.slug}.", ''
		@protocol = request.protocol
		@port = request.port != 80 ? ":#{request.port}" : ''
		
		render
	end

	def cookies
		@cookies
	end
end
