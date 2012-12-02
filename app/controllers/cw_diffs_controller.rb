class CwDiffsController < ApplicationController

	require 'diff/diff_service'

	def index
		
		@lexers = CwDiffsController.lexers
		@diff = CwDiff.new params[:cw_diff]
		
		if request.post? and @diff.build
			
			pygmentized_a = pygmentize @diff.code_a, @diff.lang
			pygmentized_b = pygmentize @diff.code_b, @diff.lang

			@size, @file_a, @file_b = Codewatch::DiffService.line_diff @diff.code_a, @diff.code_b, pygmentized_a, pygmentized_b
			@char_diff = Codewatch::DiffService.char_diff @diff.code_a, @diff.code_b

			@lines = @char_diff.lines.count
			
			render 'show'
		elsif request.post?
			flash.now[:notice] = "Invalid form input"
		end
	end
	
private

	def pygmentize code, lexer
		if lexer
			Pygments.highlight(code, lexer: lexer)
		else
			code
		end
	end

	def self.lexers
		lexers = Pygments::Lexer.all.sort { |a, b| a.name.downcase <=> b.name.downcase }
		lexers = lexers.collect { |l| [l.name, l.aliases.first] }
		lexers
	end
end
