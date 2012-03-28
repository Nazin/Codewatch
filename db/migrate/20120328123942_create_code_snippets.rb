class CreateCodeSnippets < ActiveRecord::Migration
  def change
    create_table :code_snippets do |t|
      t.string :title
      t.text :code

      t.timestamps
    end
  end
end
