class RemoveTmpFromServer < ActiveRecord::Migration
	def change
		remove_column :servers, :tmp
	end
end
