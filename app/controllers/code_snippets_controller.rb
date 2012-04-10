class CodeSnippetsController < ApplicationController
  
  def index
    @code_snippets = CodeSnippet.all
  end
  
  def new
    @lexers = @@lexers.collect { |l| [l.name, l.aliases.first] }
    @code_snippet = CodeSnippet.new
  end

  def create
    @code_snippet = CodeSnippet.new params[:code_snippet]
    if @code_snippet.save
      redirect_to @code_snippet
    else
      render 'new'
    end
  end

  def show
    @code_snippet = CodeSnippet.find params[:id]
    
    
    @a = []
    params.each { |k, v| @a << " #{k}::#{v} " }
    lexer = @code_snippet.lang
    if lexer
      @highlighted =  Pygments.highlight(@code_snippet.code, :lexer => lexer )
    else
      @highlighted = @code_snippet.code
    end
 end

private

  class << self
    @@lexers  =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
   

  end


end
