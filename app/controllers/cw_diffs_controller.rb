class CwDiffsController < ApplicationController

  require 'diff/diff_service'

  public

  def new
    @diff = CwDiff.new
    @lexers = CwDiffsController.lexers
  end


  def create
    @lexers = CwDiffsController.lexers
    @diff = CwDiff.new params[:cw_diff]
    if @diff.build
      pygmentized_a = pygmentize @diff.code_a, @diff.lang
      pygmentized_b = pygmentize @diff.code_b, @diff.lang

      @size, @file_a, @file_b = Codewatch::DiffService.line_diff(@diff.code_a, @diff.code_b, pygmentized_a, pygmentized_b)
      @char_diff = Codewatch::DiffService.char_diff(@diff.code_a, @diff.code_b)

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
