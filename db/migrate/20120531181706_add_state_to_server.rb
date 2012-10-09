class AddStateToServer < ActiveRecord::Migration

  def change
    add_column :servers, :state, :integer, :limit => 1, :default => 1, :null => false
  end
end
