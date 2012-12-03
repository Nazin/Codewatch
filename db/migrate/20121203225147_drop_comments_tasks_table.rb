class DropCommentsTasksTable < ActiveRecord::Migration
	
	def change
		drop_table :comments_tasks
	end
end
