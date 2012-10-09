class CreateLogs < ActiveRecord::Migration

	def change

		create_table :logs do |t|

			t.references :project, :null => false
			t.belongs_to :author, :null => false
			t.references :user
			t.references :task
			t.integer :ltype, :limit => 1, :null => false
			t.string :revision, :limit => 40
			t.string :branch, :limit => 40
			t.text :message

			t.timestamps
		end

		add_index :logs, :project_id
		add_index :logs, :user_id
		add_index :logs, :task_id
		add_index :logs, :author_id
	end
end
