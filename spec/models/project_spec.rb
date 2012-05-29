# == Schema Information
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(32)      not null
#  ptype      :integer(2)      not null
#  location   :string(128)     not null
#  company_id :integer         not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Project do

	let(:company) {FactoryGirl.create :company }	
	let(:user) {FactoryGirl.create :user}

	before do
		@project = company.projects.build name: "project_alpha", ptype: Project::TYPE_GIT, location: "localhost"
		@project.users << user
	end
	
	subject { @project }

	
	it { should respond_to :name }
	it { should respond_to :ptype }
	it { should respond_to :location }
	it { should respond_to :ptype }
	it { should respond_to :company_id }
	it { should respond_to :users }
	it { should respond_to :tasks } #TODO test if returns correct values
	it { should respond_to :milestones }
	its(:company) {should == company }
	it { should be_valid }


	
	describe "when name is not blank" do 
		before { @project.name = "" }
		it {should_not be_valid}
	end	

	describe "when location is blank" do 
		before { @project.location = "" }
		it {should_not be_valid}
	end

	describe "when name is too long" do
		before { @project.name = "a"*33 }
		it { should_not be_valid }
	end


	describe "when ptype has to high value" do
		before { @project.ptype = 3 }
		it { should_not be_valid }
	end


	describe "when name is not present" do 
		before { @project.name = nil }
		it {should_not be_valid}
	end	

	describe "when ptype is not present" do 
		before { @project.ptype = nil }
		it {should_not be_valid}
	end

	describe "when location is not present" do 
		before { @project.location = nil }
		it {should_not be_valid}
	end

	describe "when company_id is not present" do
		before { @project.company_id = nil }
		it { should_not be_valid }
	end

	describe "accessible attributes" do
		it "should not allow access to company_id" do
			expect do
				Project.new company_id: company.id
			end.should raise_error ActiveModel::MassAssignmentSecurity::Error
		end
	end

end
