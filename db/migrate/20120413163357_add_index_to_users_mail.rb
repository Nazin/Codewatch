class AddIndexToUsersMail < ActiveRecord::Migration
  def change
    def change
      add_index :users, :mail, unique: true
    end
  end
end
