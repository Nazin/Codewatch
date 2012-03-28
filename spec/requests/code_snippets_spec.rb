require 'spec_helper'

describe "Code snippets" do

  
  let(:base_title) {"Codewatch.pl"}
    
  
  describe "Index page" do
    
    it "should have the content 'Code Snippets'" do
      visit '/code_snippets'
      page.should have_selector 'h1', text: 'Code Snippets'
    end
    
    it "should have the right title" do
      visit '/code_snippets'
      page.should have_selector 'title', text: "#{base_title} | Code Snippets"
    end
    
  end
end


