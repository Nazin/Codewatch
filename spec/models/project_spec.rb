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

	describe "accessible attributes" do
		it "should not allow access to company_id" do
			expect do
				Project.new company_id: company.id
			end.should raise_error ActiveModel::MassAssignmentSecurity::Error
		end
	end

end
