# == Schema Information
#
# Table name: code_snippets
#
#	 id					:integer				 not null, primary key
#	 title			:string(32)			 not null
#	 code				:text						 not null
#	 created_at :datetime				 not null
#	 updated_at :datetime				 not null
#	 lang				:string(255)
#	 sha_url		:string(255)
#	 sha				:string(255)
#

class CodeSnippet < ActiveRecord::Base
	

	#TODO code duplication, @@lexers also in Controller (Diff, CodeSnippet)
	@@lexers	=	 Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
	@@lexers = @@lexers.collect { |elt| elt.aliases.first }
	


	attr_accessible :title, :code, :lang, :sha

	validates :title, presence: true, length: {maximum: 50}
	validates :code, presence: true
	validates :lang, presence: true, inclusion: { in: @@lexers }
	validates :sha, presence: true


end
