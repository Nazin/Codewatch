require 'spec_helper'

describe ServersController do

	describe "GET 'index'" do
		it "returns http success" do
			get 'index'
			response.should be_success
		end
	end

	describe "GET 'new'" do
		it "returns http success" do
			get 'new'
			response.should be_success
		end
	end

	describe "GET 'edit'" do
		it "returns http success" do
			get 'edit'
			response.should be_success
		end
	end

	describe "GET 'destroy'" do
		it "returns http success" do
			get 'destroy'
			response.should be_success
		end
	end

end
