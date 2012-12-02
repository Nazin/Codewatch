class CreateCommentsTasksTable < ActiveRecord::Migration
	def change
		create_table :comments_tasks, id: false do |t|
			t.integer :comment_id
			t.integer :task_id
		end
	end
end
