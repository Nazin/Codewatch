class AddUserToDeployment < ActiveRecord::Migration

  def change
    add_column :deployments, :user_id, :integer, :null => false
    remove_column :logs, :branch
  end
end
