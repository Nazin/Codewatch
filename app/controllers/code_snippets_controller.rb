class CodeSnippetsController < ApplicationController
	include CodeSnippetsHelper

	def index
		@code_snippets = CodeSnippet.all
	end
	
	def new
		@lexers = @@lexers
		@code_snippet = CodeSnippet.new
	end

	def create
		@code_snippet = CodeSnippet.new params[:code_snippet]
		@code_snippet.sha = sha1 @code_snippet.code
		if @code_snippet.save
			redirect_to code_snippet_sha_path(@code_snippet)
		else
			@lexers = @@lexers
			flash.now[:warning] =  "Invalid form input"
			render 'new'
		end
	end

	def show
		@code_snippet = CodeSnippet.find_by_sha params[:sha]
		unless @code_snippet
			redirect_to code_snippets_path, flash: {error: "Code snippet not found"}
		else
			@lines = @code_snippet.code.lines.count
			lexer = @code_snippet.lang
			if lexer
				@highlighted =  Pygments.highlight(@code_snippet.code, :lexer => lexer )
			else
				@highlighted = @code_snippet.code
			end
		end
	end



	private

	class << self
		@@lexers =  Pygments::Lexer.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
		@@lexers =  @@lexers.collect { |l| [l.name, l.aliases.first] }
	end

	def sha1 code
		salt = random_string 5
		Digest::SHA1.hexdigest(salt + code + salt)
	end


	def random_string len
		newstring = ""
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		1.upto(len)  { |i| newstring << chars[rand(chars.size-1)] }
		newstring
	end

end
