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
	end
		
end

