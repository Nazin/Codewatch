require 'spec_helper'

describe Project do

	let(:company) {FactoryGirl.create :company }	

	before { @project = company.projects.build name: "project_alpha", ptype: Project::TYPE_GIT, location: "localhost" }
	
	subject { @project }

	
	it { should respond_to :name }
	it { should respond_to :ptype }
	it { should respond_to :location }
	it { should respond_to :ptype }
	it { should respond_to :company_id }
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
		before { @project.ptype =3 }
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
