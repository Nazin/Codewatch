module CodeSnippetsHelper

  def code_snippet_sha_path(snippet)
    "/code_snippets/tmp/#{snippet.sha}"
  end

  def gen_line_numbers n
    numbers = "<pre  class=\"line-numbers\" >"
    1.upto(n) do |i|
      numbers << "#{i} \n"
    end
    numbers << "</pre>"
    numbers
  end

end
