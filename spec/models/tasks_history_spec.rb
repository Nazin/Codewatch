# == Schema Information
#
# Table name: tasks_histories
#
#  id                  :integer         not null, primary key
#  state               :integer(2)      not null
#  priority            :integer(2)      not null
#  posted              :datetime        not null
#  task_id             :integer         not null
#  user_id             :integer         not null
#  responsible_user_id :integer         not null
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'spec_helper'

describe TasksHistory do
	let(:task) {FactoryGirl.create :task }
	let(:user) {FactoryGirl.create :user }
	let(:responsible) {FactoryGirl.create :user }


	before do
		state = Task::State::CLOSED
		priority = Task::Priority::NEGLIGIBLE
				@task_history = task.tasks_histories.build state: state, priority: priority
		@task_history.owner = user
		@task_history.assigned_user = responsible
		@task_history.task = task
		@task_history.save!
	end

	subject { @task_history }

	it {should be_valid }

	describe "assocations" do
		it {should respond_to :owner }
		it {should respond_to :assigned_user }
		it {should respond_to :task }
	end

	it {should respond_to :priority }
	it {should respond_to :created_at }
	it {should respond_to :state }


	describe "references exists" do
		describe "task" do
			before { @task_history.task = nil }
			it { should_not be_valid }
		end
		describe "owner" do
			before { @task_history.owner = nil }
			it { should_not be_valid }
		end	
		describe "assigned_user" do
			before { @task_history.assigned_user = nil}
			it { should_not be_valid }
		end
	end
	
	describe "not nil" do
		describe "state" do
			before { @task_history.state = nil }
			it { should_not be_valid }
		end
		describe "priority" do
			before { @task_history.priority = nil }
			it { should_not be_valid }
		end	
	end

	describe "priority with not allowed value" do
		before { @task_history.priority = 123 }
		it { should_not be_valid }
	end
	
	describe "priority with allowed value" do
		before { @task_history.priority = Task::Priority.to_list[0] }
		it { should be_valid }
	end

	
	describe "state with not allowed value" do
		before { @task_history.state = 123 }
		it { should_not be_valid }
	end
	
	describe "state with allowed value" do
		before { @task_history.state = Task::State.to_list[0] }
		it { should be_valid }
	end

	
end
