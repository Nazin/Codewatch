class Comment < ActiveRecord::Base
	
	belongs_to :author, class_name: 'User'
	belongs_to :project
	
	has_many :comments, class_name: 'CommentComment', foreign_key: :comment_id
	
	validates :comment, presence: true, length: {minimum: 3}
	validates :lines, presence: true
	validates :startLine, presence: true
end
