class AddIndexToCodeSnippetsSha < ActiveRecord::Migration
  def change
    add_index :code_snippets, :sha, unique: true
  end
end
