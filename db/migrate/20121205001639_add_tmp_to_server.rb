class AddTmpToServer < ActiveRecord::Migration

	def change
		add_column :servers, :tmp, :integer
	end
end
