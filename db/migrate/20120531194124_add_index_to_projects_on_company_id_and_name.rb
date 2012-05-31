class AddIndexToProjectsOnCompanyIdAndName < ActiveRecord::Migration
  def change
	  add_index :projects, [:company_id, :name], unique: true
  end
end
