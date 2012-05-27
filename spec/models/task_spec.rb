# == Schema Information
#
# Table name: tasks
#
#  id                  :integer         not null, primary key
#  title               :string(64)      not null
#  description         :text
#  posted              :datetime
#  updated             :datetime
#  state               :integer(2)      not null
#  deadline            :date            not null
#  project_id          :integer         not null
#  user_id             :integer         not null
#  responsible_user_id :integer         not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe Task do
	
	let(:project) { FactoryGirl.create :project }
	let(:user) {FactoryGirl.create :user }
	let(:responsible_user) {FactoryGirl.create :user}

	before { @task = Task.new(title: "Task1", state: 1, deadline: 1.year.from_now)
		@task.posted = 0.days.from_now
		@task.project = project
		@task.user = user
		@task.responsible_user = responsible_user
		@task.save
		
 }
	
	subject { @task }
	
	it { should respond_to :project }
	it { should respond_to :user }
	it { should respond_to :responsible_user }
	it { should be_valid }
	
	its(:user) {should == user}
	its(:user) {should_not == responsible_user}

	its(:responsible_user) {should_not == user}
	its(:responsible_user) {should == responsible_user}

	describe "accessible attributes" do
		it "should not allow access to posted" do
			expect do
				Task.new posted: 1.year.from_now
			end.should raise_error ActiveModel::MassAssignmentSecurity::Error
		end
			it "should not allow access to user" do
			expect do
				Task.new user: user
			end.should raise_error ActiveModel::MassAssignmentSecurity::Error
		end
		it "should not allow access to updated" do
			expect do
				Task.new updated: 1.year.from_now
			end.should raise_error ActiveModel::MassAssignmentSecurity::Error
		end
		it "should not allow access to project" do
			expect do
				Task.new project: project
			end.should raise_error ActiveModel::MassAssignmentSecurity::Error
		end
	end



	describe "deadline exists" do
		before { @task.deadline = nil }
		it { should_not be_valid }
	end

	describe "posted exists" do
		before { @task.posted = nil }
		it { should_not be_valid }
	end


	describe "references exists" do
		describe "project" do
			before { @task.project = nil }
			it { should_not be_valid }
		end
		describe "user" do
			before { @task.user = nil }
			it { should_not be_valid }
		end	
		describe "responsible_user" do
			before { @task.responsible_user = nil}
			it { should_not be_valid }
		end
	end

	
	describe "title" do
		describe "not null" do
			before { @task.title = nil }
			it { should_not be_valid }
		end
		describe "not empty" do
			before { @task.title = "" }
			it { should_not be_valid }
		end	
		describe "too long" do
			before { @task.title = "a"*65}
			it { should_not be_valid }
		end
	end


end
