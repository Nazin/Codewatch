class CreateCommentComments < ActiveRecord::Migration

  def change

    create_table :comment_comments do |t|

      t.text :commentText, :null => false
      t.references :author, :null => false
      t.references :comment, :null => false

      t.timestamps
    end

    add_index :comment_comments, :author_id
    add_index :comment_comments, :comment_id
  end
end
