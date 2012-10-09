class CreateInvitations < ActiveRecord::Migration

  def change

    create_table :invitations do |t|

      t.string :mail, :limit => 64, :null => false
      t.string :key, :limit => 32, :null => false
      t.boolean :isActive, default: true
      t.references :company, :null => false
    end

    add_index :invitations, :company_id
  end
end
