class CodeSnippet < ActiveRecord::Base

	attr_accessible :title, :code

	validates :title, presence: true, length: {maximum: 50}
	validates :code, presence: true
end
