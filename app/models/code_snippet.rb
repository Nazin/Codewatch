class CodeSnippet < ActiveRecord::Base
  

  #TODO code duplication, @@lexers also in Controller (Diff, CodeSnippet)
  @@lexers  =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
  @@lexers = @@lexers.collect { |elt| elt.aliases.first }
  


	attr_accessible :title, :code, :lang, :sha

	validates :title, presence: true, length: {maximum: 50}
	validates :code, presence: true
  validates :lang, presence: true, inclusion: { in: @@lexers }
  validates :sha, presence: true


end
