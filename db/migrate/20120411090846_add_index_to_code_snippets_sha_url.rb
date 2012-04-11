class AddIndexToCodeSnippetsShaUrl < ActiveRecord::Migration
  def change
    add_index :code_snippets, :sha_url, unique: true
  end
end
