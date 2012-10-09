class CreateUserActions < ActiveRecord::Migration

  def change

    create_table :user_actions do |t|
      t.string :key, :limit => 32, :null => false
      t.integer :type, :limit => 1, :null => false
      t.references :user, :null => false
    end

    add_index :user_actions, :user_id
  end
end
