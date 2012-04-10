# == Schema Information
#
# Table name: code_snippets
#
#  id         :integer         not null, primary key
#  title      :string(32)      not null
#  code       :text            not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class CodeSnippet < ActiveRecord::Base

	attr_accessible :title, :code

	validates :title, presence: true, length: {maximum: 50}
	validates :code, presence: true
end


