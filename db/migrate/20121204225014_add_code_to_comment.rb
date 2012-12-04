class AddCodeToComment < ActiveRecord::Migration
	
	def change
		add_column :comments, :code, :text
	end
end
