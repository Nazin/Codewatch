class CreateCompanies < ActiveRecord::Migration

  def change

    create_table :companies do |t|

      t.string :name, :limit => 32, :null => false
      t.string :slug, :null => false
    end
  end
end
