class CreateServers < ActiveRecord::Migration

  def change

    create_table :servers do |t|

      t.string :name, :limit => 64, :null => false
      t.text :localRepoPath, :null => false
      t.text :remotePath, :null => false
      t.integer :stype, :limit => 1, :null => false
      t.string :host, :limit => 64, :null => false
      t.integer :port, :limit => 4, :null => false
      t.string :password, :limit => 64, :null => false
      t.references :project, :null => false
    end

    add_index :servers, :project_id
  end
end
