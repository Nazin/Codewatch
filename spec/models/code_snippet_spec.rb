require 'spec_helper'

describe CodeSnippet do

  before { @snippet = CodeSnippet.new(title: "my_code_snippet", code: "def a end", lang: "ruby") }

  subject { @snippet }

  it { should respond_to :title }
  it { should respond_to :code  }
  it { should respond_to :lang  }
end

