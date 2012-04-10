class AddLangToCodeSnippets < ActiveRecord::Migration
  def change
    add_column :code_snippets, :lang, :string

  end
end
