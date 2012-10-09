class CreateCodeSnippets < ActiveRecord::Migration

  def change

    create_table :code_snippets do |t|

      t.string :title, :limit => 32, :null => false
      t.text :code, :null => false

      t.timestamps
    end
  end
end
