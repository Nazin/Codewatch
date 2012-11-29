class UnauthorizedUserHeaderCell < Cell::Rails

	build do |opts|
		CompanyHeaderCell if !@company.nil?
	end

	def display args
		
		@signed_in = args[:signed_in]
		@user = args[:user]
		
		@host = request.host
		@protocol = request.protocol
		@port = request.port != 80 ? ":#{request.port}" : ''
		
		render
	end
end
