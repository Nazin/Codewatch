FactoryGirl.define do
	factory :user do
		sequence(:name)	 { |n| "Person #{n}" }
		sequence(:mail) { |n| "person_#{n}@example.com"}	 
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	
	factory :company do
		name "Google"
		slug "goo"
	end

	factory :project do
		name "my_project"
		ptype 1
		location "my_location"
		company
		user
	end

	factory :task do
		title "moj task"
		description "to jest bardzo trudny task"
		posted 1.day.ago
		updated 1.hour.ago
		state Task::State::ACTIVE
		priority Task::Priority::IMPORTANT
		deadline 2.days.from_now
		responsible_user user
		project
		users [user]
	end
		
end

