class Deployment < ActiveRecord::Base
	
	belongs_to :server
	
	class State
		
		FINE = 1
		CONNECTION_PROBLEM = 2
		ACCESSIBILITY_PROBLEM = 3
		WRITE_PROBLEM = 4
		
		def self.to_hash
			{
				'Fine' => FINE,
				'Connection problem' => CONNECTION_PROBLEM,
				'Path access problem' => ACCESSIBILITY_PROBLEM,
				'Write problem' => WRITE_PROBLEM
			}
		end
		
		def self.to_list
			to_hash
		end
	end
end
