class AddSlugToProject < ActiveRecord::Migration
	
	def change
		add_column :projects, :slug, :string, :null => false
	end
end
