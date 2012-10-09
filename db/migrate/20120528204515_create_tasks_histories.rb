class CreateTasksHistories < ActiveRecord::Migration
	def change
		create_table :tasks_histories do |t|
			t.integer :state, limit: 1, null: false
			t.integer :priority, limit: 1, null: false
			t.references :task, null: false
			#	t.references :milestone, null: false
			t.references :user, null: false
			t.belongs_to :responsible_user, null: false

			t.timestamps
		end
	end
end
