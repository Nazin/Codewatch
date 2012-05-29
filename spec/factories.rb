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
		sequence(:name)	 { |n| "Google#{n}" }		
		slug "goo"
	end

	factory :project do
		sequence(:name)	 { |n| "my_project#{n}" }
		ptype 1
		location "my_location"
		company
		after_build do |p|
			p.users << FactoryGirl.create(:user)
		end
	end

	factory :milestone do
		sequence(:name)	 { |n| "majlstoln#{n}" }
		deadline 1.month.from_now
		project
	end

	factory :task do
		sequence(:title)	 { |n| "maj task#{n}" }
		description "to jest bardzo trudny task"
		posted 1.day.ago
		updated 1.hour.ago
		state Task::State::ACTIVE
		priority Task::Priority::IMPORTANT
		deadline 2.days.from_now
		project
	
		after_build do |t|
			t.owner =  FactoryGirl.create(:user)
			t.assigned_user = FactoryGirl.create(:user)
			t.milestone = FactoryGirl.create(:milestone)
	end
	end
		
end

