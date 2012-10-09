class AddAvatarToUser < ActiveRecord::Migration

	def change
		add_column :users, :avatar, :string, :limit => 16
		remove_column :users, :havePicture
	end
end
