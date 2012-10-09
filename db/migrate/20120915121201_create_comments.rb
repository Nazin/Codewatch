class CreateComments < ActiveRecord::Migration

	def change

		create_table :comments do |t|

			t.string :path, :null => false
			t.string :blob, :limit => 40, :null => false
			t.string :revision, :limit => 40, :null => false
			t.integer :startLine, :limit => 3, :null => false
			t.integer :lines, :limit => 3, :null => false
			t.text :comment, :null => false
			t.references :author, :null => false

			t.timestamps
		end

		add_index :comments, :author_id
	end
end
