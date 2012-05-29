class CreateTasks < ActiveRecord::Migration
	def change
		create_table :tasks do |t|
			t.string :title, limit: 64, null: false
			t.text :description 
			t.timestamp :posted, null: false
			t.timestamp :updated
			t.integer :state, limit: 1, null: false
			t.integer :priority, limit: 1, null: false
			t.date :deadline
			t.references :project, null: false
			t.references :milestone, null: false
			t.references :user, null: false
			t.belongs_to :responsible_user, null: false

			t.timestamps
		end
	end

end
