class DiffsController < ApplicationController
  require 'diff_file'
private   
  class << self
    @@lexers =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
    @@lexers =  @@lexers.collect { |l| [l.name, l.aliases.first] }
  end

public 
  def diff
  end

  def new 
    @lexers = @@lexers
  end


  def create
    inits = {}
    @snippets = []
    #TODO refactor params, -> new.html.erb
    lang = params[:diff][:lang]
    title = params[:title]
    code_1 = params[:code_1]
    code_2 = params[:code_2]
   

    @diff_a, @diff_b = Codewatch::DiffFile.diff code_1, code_2
    pygmentized_a = pygmentize code_1, lang
    pygmentized_b = pygmentize code_2, lang
    Rails.logger.fatal "1111111111111111111111111111111111"

    


    merge_diff_with_pygments! @diff_a, pygmentized_a
    merge_diff_with_pygments! @diff_b, pygmentized_b

    render 'show'
  end
 

private

 #TODO lexer
 def pygmentize code, lexer
   if lexer
     Pygments.highlight(code, lexer: "ruby" )
   else
     code
   end
 end
 
 def merge_diff_with_pygments! diff_file, pygmentized_code
   lines = pygmentized_code.lines.to_a
   lines.each do |line|
     line.gsub! "\n",""
   end
 
   return diff_file if lines.size == 0

   lines[0]["<div class=\"highlight\"><pre>"]=""
   diff_file.each_real_with_index do |line, i|
     line.line = lines[i]
   end
   diff_file
 end
 
end
