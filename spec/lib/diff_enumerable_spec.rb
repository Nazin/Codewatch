require "rspec"
require 'spec_helper'
require 'diff_enumerable'

module Codewatch


	describe "DiffEnumerable" do

		describe "with String as input" do

			describe "basic diff" do

				before do
					@tested_diff = DiffEnumerable.new("code_a", "code_b")
				end

				it "has size of 3" do
					diff_elements = @tested_diff.to_a
					diff_elements.size.should == 3
					diff_elements[0].should == ["code_", :lcs]
					diff_elements[1].should == ["a", :-]
					diff_elements[2].should == ["b", :+]
				end

			end

			describe "first file has additional chars" do

				before do
					@expected_result = [["ab", :lcs], ["cd", :-], ["", :+], ["e", :lcs], ["f", :-], ["", :+]]
					@tested_diff = DiffEnumerable.new("abcdef", "abe")
				end

				it "enumaretes changed fragments in order" do
					@tested_diff.to_a.should == @expected_result
				end

			end

			describe "first file has  missing chars" do

				before do
					@expected_result = [["ab", :lcs], ["", :-], ["cd", :+], ["e", :lcs], ["", :-], ["f", :+]]
					@tested_diff = DiffEnumerable.new("abe", "abcdef")
				end

				it "enumaretes changed fragments in order" do
					@tested_diff.to_a.should == @expected_result
				end

			end

			describe "first file has  missing and additional chars" do

				before do
					@expected_result = [["a", :lcs], ["g", :-], ["", :+], ["b", :lcs], ["", :-], ["c", :+], ["de", :lcs], ["", :-], ["f", :+]]
					@tested_diff = DiffEnumerable.new("agbde", "abcdef")
				end

				it "enumaretes changed fragments in order" do
					@tested_diff.to_a.should == @expected_result
				end

			end

			describe "common suffix" do

				before do
					@expected_result = [["a", :lcs], ["g", :-], ["", :+], ["b", :lcs], ["", :-], ["c", :+], ["de", :lcs], ["", :-], ["f", :+], ["aaaa", :lcs], ["", :-], ["", :+]]
					@tested_diff = DiffEnumerable.new("agbdeaaaa", "abcdefaaaa")
				end

				it "enumaretes changed fragments in order" do
					@tested_diff.to_a.should == @expected_result
				end

			end

		end

		describe "with Array of Strings as input (lines_mode)" do

			describe "common suffix" do
				before do
					@expected_result = [["aaa", :lcs], ["bbb", :-], ["ddd", :+], ["ccac", :+], ["ccc", :lcs]]
					a, b = ["aaa", "bbb", "ccc"], ["aaa", "ddd", "ccac", "ccc"]
					@tested_diff = DiffEnumerable.new(a, b).lines_mode
				end

				it "enumaretes changed fragments in order" do
					@tested_diff.to_a.should == @expected_result
				end
			end

		end
	end
end