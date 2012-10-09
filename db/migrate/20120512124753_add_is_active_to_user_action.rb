class AddIsActiveToUserAction < ActiveRecord::Migration

	def change
		add_column :user_actions, :isActive, :boolean, default: true
	end
end
