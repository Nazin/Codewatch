class AddRepositoryCreatedToProjects < ActiveRecord::Migration
	def change
		add_column :projects, :repository_created, :boolean, defult: false
	end
end
