class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :name, null: false, limit: 32
      t.timestamp :deadline
      t.references :project, null: false

      t.timestamps
    end

  end
end
