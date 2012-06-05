class DropPtypeFromProjects < ActiveRecord::Migration
	
	def change
		remove_column :projects, :ptype
	end
end
