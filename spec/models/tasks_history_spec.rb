require 'spec_helper'

describe TasksHistory do
	let(:task) {FactoryGirl.create :task }
	let(:user) {FactoryGirl.create :user }
	let(:responsible) {FactoryGirl.create :user }


	before do
		state = Task::State::CLOSED
		priority = Task::Priority::NEGLIGIBLE
		posted = 1.minute.ago #task.updated
			@task_history = task.tasks_histories.build state: state, priority: priority, posted: posted
		@task_history.user = user
		@task_history.responsible_user = responsible
		@task_history.task = task
		@task_history.save!
	end

	subject { @task_history }

	it {should be_valid }
end
