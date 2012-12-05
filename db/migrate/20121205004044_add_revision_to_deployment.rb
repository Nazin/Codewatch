class AddRevisionToDeployment < ActiveRecord::Migration
	
	def change
		add_column :deployments, :revision, :string
	end
end
