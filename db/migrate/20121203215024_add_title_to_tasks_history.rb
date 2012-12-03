class AddTitleToTasksHistory < ActiveRecord::Migration
	
	def change
		
		add_column :tasks_histories, :title, :string
	end
end
