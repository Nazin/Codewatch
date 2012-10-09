class AddStateToDeployment < ActiveRecord::Migration

  def change
    add_column :deployments, :state, :integer, :limit => 1, :default => 1, :null => false
  end
end
