module CodeSnippetsHelper

  def code_snippet_sha_path(snippet)
    "/code_snippets/tmp/#{snippet.sha}"
  end



end
