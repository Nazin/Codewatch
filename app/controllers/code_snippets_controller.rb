class CodeSnippetsController < ApplicationController
  def new
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
    @highlighted =  Pygments.highlight(@code_snippet.code, :lexer => 'ruby' )
 end
end
