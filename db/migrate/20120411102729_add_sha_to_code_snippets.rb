class AddShaToCodeSnippets < ActiveRecord::Migration
	def change
		add_column :code_snippets, :sha, :string

	end
end
