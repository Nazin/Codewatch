# == Schema Information
#
# Table name: code_snippets
#
#  id         :integer         not null, primary key
#  title      :string(32)      not null
#  code       :text            not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  lang       :string(255)
#  sha        :string(255)
#

require 'spec_helper'

describe CodeSnippet do

	before { @snippet = CodeSnippet.new(title: "my_code_snippet", code: "def a end", lang: "ruby") }

	subject { @snippet }

	it { should respond_to :title }
	it { should respond_to :code }
	it { should respond_to :lang }
end

