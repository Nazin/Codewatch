class CreateProjects < ActiveRecord::Migration

	def change

		create_table :projects do |t|
			t.string :name, :limit => 32, :null => false
			t.integer :ptype, :limit => 1, :null => false
			t.string :location, :limit => 128, :null => false
			t.references :company, :null => false

			t.timestamps
		end

		add_index :projects, :company_id
	end
end
