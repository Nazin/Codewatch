class AddDescriptionAndDeadlineToTaskHistory < ActiveRecord::Migration

	def change
		
		add_column :tasks_histories, :description, :text
		add_column :tasks_histories, :deadline, :date
	end
end
