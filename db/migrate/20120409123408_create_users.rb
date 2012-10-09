class CreateUsers < ActiveRecord::Migration

	def change

		create_table :users do |t|
			t.string :mail, :limit => 64, :null => false
			t.string :name, :limit => 32, :null => false
			t.string :passHash, :limit => 40, :null => false
			t.string :passSalt, :limit => 5, :null => false
			t.string :fullName, :limit => 64
			t.boolean :havePicture, :default => false

			t.timestamps
		end
		add_index :users, :mail
	end
end
