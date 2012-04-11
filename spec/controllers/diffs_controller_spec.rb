require 'spec_helper'

describe DiffController do

  describe "GET 'diff'" do
    it "returns http success" do
      get 'diff'
      response.should be_success
    end
  end

end
