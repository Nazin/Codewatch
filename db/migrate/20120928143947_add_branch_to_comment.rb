class AddBranchToComment < ActiveRecord::Migration

	def change

		add_column :comments, :branch, :string
	end
end
