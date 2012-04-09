class CreateUserCompanies < ActiveRecord::Migration
	
	def change
		
		create_table :user_companies do |t|
			
			t.references :user, :null => false
			t.references :company, :null => false
			t.integer :role, :limit => 1, :null => false
		end
		
		add_index :user_companies, :user_id
		add_index :user_companies, :company_id
	end
end
