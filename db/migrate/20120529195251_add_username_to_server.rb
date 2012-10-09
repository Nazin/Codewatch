class AddUsernameToServer < ActiveRecord::Migration

  def change
    add_column :servers, :username, :string, :limit => 64, :null => false
  end
end
