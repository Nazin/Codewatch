class DiffsController < ApplicationController
  require 'diff_file'

public 
 
  def new 
    @diff = CwDiff.new
    @lexers = DiffsController.lexers
  end


  def create
    @lexers = DiffsController.lexers
    @diff = CwDiff.new params[:diff]
    if @diff.build
      @diff_a, @diff_b = Codewatch::DiffFile.diff @diff.code_a, @diff.code_b
      pygmentized_a = pygmentize @diff.code_a, @diff.lang
      pygmentized_b = pygmentize @diff.code_b, @diff.lang
      merge_diff_with_pygments! @diff_a, pygmentized_a
      merge_diff_with_pygments! @diff_b, pygmentized_b
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
   return diff_file if lines.size == 0

   lines.each do |line|
     line.gsub! "\n",""
   end
   
   #TODO refactor
   lines[0]["<div class=\"highlight\"><pre>"]=""
   diff_file.each_real_with_index do |line, i|
     line.line = lines[i]
   end
   diff_file
 end


 def self.lexers
   lexers =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase}
   lexers =  lexers.collect { |l| [l.name, l.aliases.first] }
   lexers
 end
  
end
