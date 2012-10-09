class RemovePassSaltFromUsers < ActiveRecord::Migration
	def up
		remove_column :users, :passSalt
	end

	def down
		add_column :users, :passSalt, :string
	end
end
