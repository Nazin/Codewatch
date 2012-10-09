class AddAtypeToUserAction < ActiveRecord::Migration

  def change
    add_column :user_actions, :atype, :integer, :limit => 1, :null => false
    remove_column :user_actions, :type
  end
end
