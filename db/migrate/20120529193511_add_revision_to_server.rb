class AddRevisionToServer < ActiveRecord::Migration

  def change
    add_column :servers, :revision, :string, :limit => 64
    add_column :servers, :autoUpdate, :boolean, :default => false
  end
end
