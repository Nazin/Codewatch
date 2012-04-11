class AddShaUrlToCodeSnippet < ActiveRecord::Migration
  def change
    add_column :code_snippets, :sha_url, :string

  end
end
