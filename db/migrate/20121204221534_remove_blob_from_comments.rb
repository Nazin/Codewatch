class RemoveBlobFromComments < ActiveRecord::Migration
	def change
		remove_column :comments, :blob
	end
end
