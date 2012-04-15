require 'spec_helper'

describe "Code snippets" do

	
	subject { page }

	let(:base_title) {"Codewatch.pl"}
		
	
	describe "Index page" do
		

		before do
			visit '/code_snippets'
		end
		
		describe "should have the content 'Code Snippets'" do
			it { should have_selector 'h1', text: 'Code Snippets' }
		end
		
		describe "should have the right title" do
			it { should have_selector 'title', text: "#{base_title} | Code Snippets" }
		end

		describe "should have link to new code snippet" do
			it { should have_link('Create new', href: new_code_snippet_path) }
		end	 
	end

	describe "New page" do
		

		before do
			visit '/code_snippets/new'
		end
		
		describe "should have the content 'Code Snippets'" do
			it { should have_selector 'h1', text: 'Code Snippets' }
		end
		
		describe "should have the right title" do
			it { should have_selector 'title', text: "#{base_title} | Code Snippets" }
		end

		describe "should have link to new code snippet" do
			it { should have_link('Snippets home', href: code_snippets_path) }
		end
		
		
		
	end

end


