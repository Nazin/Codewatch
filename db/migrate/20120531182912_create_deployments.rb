class CreateDeployments < ActiveRecord::Migration

  def change

    create_table :deployments do |t|

      t.integer :filesTotal, :limit => 5, :null => false
      t.integer :filesProceeded, :limit => 5, :default => 0, :null => false
      t.boolean :finished, :default => false, :null => false
      t.text :info
      t.references :server, :null => false

      t.timestamps
    end

    add_index :deployments, :server_id
  end
end
