class DiffsController < ApplicationController
  def diff
  end

  def new 
    @code_v1 = CodeSnippet.new
    @code_v2 = CodeSnippet.new
    @lexers = @@lexers
  end


  def create
    inits = {}
    @snippet = []
    inits[:lang] = params[:diff][:lang]
    inits[:title] = params[:title]
    inits[:code] = params[:code_1]
    @snippet[0] = CodeSnippet.new inits
    inits[:code] = params[:code_2]
    @snippet[1] = CodeSnippet.new inits
    @highlighted = []
    @lines = []
    show_x 0
    show_x 1
    render 'show'
  end

 def show_x index
    
      @lines[index] = @snippet[index].code.lines.count
      lexer = @snippet[index].lang
      if lexer
        @highlighted[index] =  Pygments.highlight(@snippet[index].code, :lexer => lexer )
      else
        @highlighted[index] = @snippet[index].code
      end

    

 end

private
  class << self
    @@lexers =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
    @@lexers =  @@lexers.collect { |l| [l.name, l.aliases.first] }
  end 
end
