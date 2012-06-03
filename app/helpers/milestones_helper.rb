module MilestonesHelper
	def deadline milestone
		if milestone.deadline.nil?
			"-- no deadline date specified --"
		else
		 milestone.deadline 
		end
	end

	

end
