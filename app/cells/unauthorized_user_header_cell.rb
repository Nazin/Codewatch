class UnauthorizedUserHeaderCell < Cell::Rails

	build do |opts|
		CompanyHeaderCell if !@company.nil?
	end

	def display(args)
		render
	end
end
