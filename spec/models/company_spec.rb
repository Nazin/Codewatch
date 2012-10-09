# == Schema Information
#
# Table name: companies
#
#	 id		:integer				 not null, primary key
#	 name :string(32)			 not null
#	 slug :string(255)		 not null
#

require 'spec_helper'

describe Company do

  #TODO moar tests

  before { @company = Company.new name: "HP", slug: "hp" }

  subject { @company }

  it { should respond_to :name }
  it { should respond_to :slug }

  it { should respond_to :projects }
  it { should respond_to :user_companies }
  it { should respond_to :users }

  describe "when name is blank" do
    before { @company.name = "" }
    it { should_not be_valid }
  end


  describe "when slug is nil" do
    before { @company.slug = nil }
    it { should_not be_valid }
  end


  describe "when name is nil" do
    before { @company.name = nil }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @company.name = "a"*33 }
    it { should_not be_valid }
  end
end
