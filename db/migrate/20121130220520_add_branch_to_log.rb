class AddBranchToLog < ActiveRecord::Migration
	
	def change
		
		add_column :logs, :branch, :string
	end
end
