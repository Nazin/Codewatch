class CwDiffsController < ApplicationController
	require 'diff_file'
  require 'diff_lsc_lib'

	public 
	
	def new 
		@diff = CwDiff.new
		@lexers = CwDiffsController.lexers
	end


	def create
		@lexers = CwDiffsController.lexers
		@diff = CwDiff.new params[:cw_diff]
		if @diff.build
			@diff_a, @diff_b = Codewatch::DiffFile.diff @diff.code_a, @diff.code_b
			pygmentized_a = pygmentize @diff.code_a, @diff.lang
			pygmentized_b = pygmentize @diff.code_b, @diff.lang
      @diff_a = merge_diff_with_pygments!(@diff_a, pygmentized_a)
      @diff_b = merge_diff_with_pygments!(@diff_b, pygmentized_b)

      @char_diff = Codewatch::DiffLcsLib.execute_diff @diff.code_a, @diff.code_b
			render 'show'
		else
			flash.now[:notice] = "Invalid form input"
			render 'new'
		end
	end

	private

	#TODO lexer
	def pygmentize code, lexer
		if lexer
			Pygments.highlight(code, lexer: lexer )
		else
			code
		end
	end
	
	def merge_diff_with_pygments! diff_file, pygmentized_code
		lines = pygmentized_code.lines.to_a
		return diff_file if lines.empty?

    lines = remove_newline_characters(lines)
		
		#TODO refactor
		lines[0]["<div class=\"highlight\"><pre>"]=""
		diff_file.each_real_with_index do |line, i|
			line.line = lines[i]
		end
		diff_file
	end

  def remove_newline_characters(lines)
    lines.each do |line|
      line.gsub! "\n", ""
    end
  end


  def self.lexers
		lexers =	Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase}
		lexers =	lexers.collect { |l| [l.name, l.aliases.first] }
		lexers
	end
	
end
