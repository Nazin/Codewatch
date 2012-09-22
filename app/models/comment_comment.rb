class CommentComment < ActiveRecord::Base
	
	belongs_to :author, class_name: 'User'
	belongs_to :comment
	
	validates :commentText, presence: true, length: {minimum: 3}
end
