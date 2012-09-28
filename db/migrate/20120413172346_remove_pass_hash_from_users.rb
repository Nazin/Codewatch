class RemovePassHashFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :passHash
  end

  def down
    add_column :users, :passHash, :string
  end
end
