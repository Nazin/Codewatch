class AddRoleToInvitation < ActiveRecord::Migration

	def change
		add_column :invitations, :role, :integer, :limit => 1, :null => false
	end
end
