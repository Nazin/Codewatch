class AddIsActiveToUser < ActiveRecord::Migration
	
	def change
		add_column :users, :isActive, :boolean, default: false
	end
end
